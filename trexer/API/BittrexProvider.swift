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
    func balances() -> AnyPublisher<Balances, BittrexError>
    func orders() -> AnyPublisher<Orders, BittrexError>
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
    
    private func fetch<T>(with url: URL?, secretKey: String? = nil) -> AnyPublisher<T, BittrexError> where T: Decodable {
        guard let url = url else {
            return Fail(error: .network(description: "Couldn't create URL")).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        
        if let secretKey = secretKey,
            let sign = Crypto.hmac(mixString: url.absoluteString, secretKey: secretKey) {
            urlRequest = URLRequest(url: url)
            urlRequest.addValue(sign, forHTTPHeaderField: "apisign")
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
        fetch(with: URLComponents(string: "\(domain)/api/v2.0/pub/currencies/GetBTCPrice")?.url)
    }
    
    func markets() -> AnyPublisher<Markets, BittrexError> {
        fetch(with: URLComponents(string: "\(domain)/api/v2.0/pub/Markets/GetMarketSummaries")?.url)
    }
    
    func balances() -> AnyPublisher<Balances, BittrexError> {
        fetch(with: URLComponents(string: "\(domain)/api/v1.1/account/getbalances?apikey=\(apiKey)&nonce=\(Date.epochTime)")?.url, secretKey: secretKey)
    }
    
    func orders() -> AnyPublisher<Orders, BittrexError> {
        fetch(with: URLComponents(string: "\(domain)/api/v1.1/account/getorderhistory?apikey=\(apiKey)&nonce=\(Date.epochTime)")?.url, secretKey: secretKey)
    }
}

private extension Date {
    static var epochTime: Double {
        floor(NSDate().timeIntervalSince1970)
    }
}
