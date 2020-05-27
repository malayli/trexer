//
//  Order.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Order: Codable {
    let id: String
    let marketSymbol: String
    let direction: String
    let type: String
    let quantity: String
    let timeInForce: String
    let fillQuantity: String
    let commission: String
    let proceeds: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let closedAt: String
    let limit: String?
    
    enum OrderType: String {
        case sell
        case buy
        case unknown
    }
    
    var orderType: OrderType {
        switch direction {
        case "SELL":
            return .sell
        case "BUY":
            return .buy
        default:
            return .unknown
        }
    }
}
