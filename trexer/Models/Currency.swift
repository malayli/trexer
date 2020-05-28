//
//  Currency.swift
//  trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Currency: Decodable {
    let symbol: String
    let name: String
    let coinType: String
    let status: String
    let txFee: String
    let logoUrl: String?
}
