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
    func orders() -> AnyPublisher<Orders, BittrexError>
}

enum APIVersion {
    case none
    case v1
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
        case .v1:
            if let sign = Crypto.hmac(mixString: url.absoluteString, secretKey: secretKey) {
                urlRequest.addValue(sign, forHTTPHeaderField: "apisign")
            }
        case .v3:
            let timeStamp = "\(Int(Date.epochTime))000"
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
    
    func orders() -> AnyPublisher<Orders, BittrexError> {
        fetch(with: URLComponents(string: "\(domain)/api/v1.1/account/getorderhistory?apikey=\(apiKey)&nonce=\(Date.epochTime)")?.url, apiVersion: .v1)
    }
}

private extension Date {
    static var epochTime: Double {
        floor(NSDate().timeIntervalSince1970)
    }
}
