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
        let bpi: BPI
        
        struct BPI: Codable {
            let USD: USD
            
            struct USD: Codable {
                enum CodingKeys: String, CodingKey {
                    case rateFloat = "rate_float"
                }
                let rateFloat: Double
            }
        }
    }
}
