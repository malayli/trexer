//
//  Balance.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Balance: Codable {
    let currencySymbol: String
    let total: String
    let available: String
    let updatedAt: String
}
