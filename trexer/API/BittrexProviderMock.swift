//
//  BittrexProviderMock.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation
import Combine

struct BittrexProviderMock {
    private let data: Data
    private let apiKey = ""
    private let domain = ""
    
    init(data: Data) {
        self.data = data
    }
}

extension BittrexProviderMock: BittrexFetching {
    init(_ urlSession: URLSession, apiKey: String, secretKey: String) {
        self.data = Data()
    }
    
    func bitcoin() -> AnyPublisher<Currency, BittrexError> {
        let publisher: AnyPublisher<Currency, BittrexError> = Parser.decode(data)
        return publisher.mapError { error in
            .network(description: error.localizedDescription)
        }.eraseToAnyPublisher()
    }
    
    func markets() -> AnyPublisher<Markets, BittrexError> {
        let publisher: AnyPublisher<Markets, BittrexError> = Parser.decode(data)
        return publisher.mapError { error in
            .network(description: error.localizedDescription)
        }.eraseToAnyPublisher()
    }
    
    func balances() -> AnyPublisher<[Balance], BittrexError> {
        let publisher: AnyPublisher<[Balance], BittrexError> = Parser.decode(data)
        return publisher.eraseToAnyPublisher()
    }
    
    func orders() -> AnyPublisher<Orders, BittrexError> {
        let publisher: AnyPublisher<Orders, BittrexError> = Parser.decode(data)
        return publisher.eraseToAnyPublisher()
    }
}
