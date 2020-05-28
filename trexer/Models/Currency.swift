//
//  Currency.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Currency: Codable {
    let result: Result
    
    struct Result: Codable {
        enum CodingKeys: String, CodingKey {
            case bid = "Bid"
            case ask = "Ask"
            case last = "Last"
        }
        let bid: Double
        let ask: Double
        let last: Double
    }
}
