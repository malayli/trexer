//
//  Data.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation
import Combine

public struct Parser {
    static func load(_ filename: String) -> Data {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            return try Data(contentsOf: file)
            
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
    }

    static func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, BittrexError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970

        return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
            .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}
