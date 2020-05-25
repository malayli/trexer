//
//  Balances.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Balances: Codable {
    var result: [Balance]
    
    struct Balance: Codable {
        enum CodingKeys: String, CodingKey {
            case currency = "Currency"
            case balance = "Balance"
            case available = "Available"
            case pending = "Pending"
            case cryptoAddress = "CryptoAddress"
        }
        
        let currency: String
        let balance: Double
        let available: Double
        let pending: Double
        let cryptoAddress: String?
    }
}
