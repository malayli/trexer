//
//  BittrexProvider.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation
import Combine

enum BittrexError: Error {
  case parsing(description: String)
  case network(description: String)
}

protocol BittrexFetching {
    func bitcoin() -> AnyPublisher<Currency, BittrexError>
    func markets() -> AnyPublisher<Markets, BittrexError>
    func balances() -> AnyPublisher<[Balance], BittrexError>
    func orders() -> AnyPublisher<[Order], BittrexError>
}

enum APIVersion {
    case none
    case v3
}

struct BittrexProvider {
    private let session: URLSession
    private let apiKey: String
    private let secretKey: String
    private let domain = "api.bittrex.com"
    
    init(_ urlSession: URLSession = URLSession.shared, apiKey: String, secretKey: String) {
        self.session = urlSession
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    private func fetch<T>(with url: URL?, isSigned: Bool = false) -> AnyPublisher<T, BittrexError> where T: Decodable {
        guard let url = url else {
            return Fail(error: .network(description: "Couldn't create URL")).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        
        if isSigned {
            let timeStamp = "\(Int(Date.epochTimeInMilliseconds))"
            let uri = url.absoluteString
            let contentHash = Crypto.sha512Hex(string: "")
            let preSign = [timeStamp, uri, "GET", contentHash].joined()
            let signature = Crypto.hmac(mixString: preSign, secretKey: secretKey) ?? ""
            
            urlRequest.addValue(apiKey, forHTTPHeaderField: "Api-Key")
            urlRequest.addValue(timeStamp, forHTTPHeaderField: "Api-Timestamp")
            urlRequest.addValue(contentHash, forHTTPHeaderField: "Api-Content-Hash")
            urlRequest.addValue(signature, forHTTPHeaderField: "Api-Signature")
        }
        
        return session.dataTaskPublisher(for: urlRequest)
        .mapError { error in
            .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            Parser.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
}

extension BittrexProvider: BittrexFetching {
    func bitcoin() -> AnyPublisher<Currency, BittrexError> {
        fetch(with: URLComponents(string: "https://\(domain)/api/v1.1/public/getticker?market=USD-BTC")?.url)
    }
    
    func markets() -> AnyPublisher<Markets, BittrexError> {
        fetch(with: URLComponents(string: "https://\(domain)/api/v1.1/public/getmarketsummaries")?.url)
    }
    
    func balances() -> AnyPublisher<[Balance], BittrexError> {
        fetch(with: URLComponents(string: "https://\(domain)/v3/balances")?.url, isSigned: true)
    }
    
    func orders() -> AnyPublisher<[Order], BittrexError> {
        fetch(with: URLComponents(string: "https://\(domain)/v3/orders/closed")?.url, isSigned: true)
    }
}

private extension Date {
    static var epochTimeInMilliseconds: Double {
        NSDate().timeIntervalSince1970 * 1000.0
    }
}
