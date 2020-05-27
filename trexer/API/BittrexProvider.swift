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
    private let domain = "https://bittrex.com"
    
    init(_ urlSession: URLSession = URLSession.shared, apiKey: String, secretKey: String) {
        self.session = urlSession
        self.apiKey = apiKey
        self.secretKey = secretKey
    }
    
    private func fetch<T>(with url: URL?, apiVersion: APIVersion) -> AnyPublisher<T, BittrexError> where T: Decodable {
        guard let url = url else {
            return Fail(error: .network(description: "Couldn't create URL")).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        
        switch apiVersion {
        case .v3:
            let timeStamp = "\(Int(Date.epochTimeInMilliseconds))"
            let uri = url.absoluteString
            let contentHash = Crypto.sha512Hex(string: "")
            let preSign = [timeStamp, uri, "GET", contentHash].joined()
            let signature = Crypto.hmac(mixString: preSign, secretKey: secretKey) ?? ""
            
            urlRequest.addValue(apiKey, forHTTPHeaderField: "Api-Key")
            urlRequest.addValue(timeStamp, forHTTPHeaderField: "Api-Timestamp")
            urlRequest.addValue(contentHash, forHTTPHeaderField: "Api-Content-Hash")
            urlRequest.addValue(signature, forHTTPHeaderField: "Api-Signature")
        case .none: ()
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
        fetch(with: URLComponents(string: "\(domain)/api/v2.0/pub/currencies/GetBTCPrice")?.url, apiVersion: .none)
    }
    
    func markets() -> AnyPublisher<Markets, BittrexError> {
        fetch(with: URLComponents(string: "\(domain)/api/v2.0/pub/Markets/GetMarketSummaries")?.url, apiVersion: .none)
    }
    
    func balances() -> AnyPublisher<[Balance], BittrexError> {
        fetch(with: URLComponents(string: "https://api.bittrex.com/v3/balances")?.url, apiVersion: .v3)
    }
    
    func orders() -> AnyPublisher<[Order], BittrexError> {
        fetch(with: URLComponents(string: "https://api.bittrex.com/v3/orders/closed")?.url, apiVersion: .v3)
    }
}

private extension Date {
    static var epochTimeInMilliseconds: Double {
        NSDate().timeIntervalSince1970 * 1000.0
    }
}
