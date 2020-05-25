//
//  Order.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Orders: Codable {
    var result: [Order]
    
    struct Order: Codable {
        enum CodingKeys: String, CodingKey {
            case orderUuid = "OrderUuid"
            case exchange = "Exchange"
            case timeStamp = "TimeStamp"
            case type = "OrderType"
            case quantity = "Quantity"
            case price = "Price"
            case pricePerUnit = "PricePerUnit"
            case closed = "Closed"
        }
        
        let orderUuid: String
        let exchange: String
        let timeStamp: String
        let type: String
        let quantity: Double
        let price: Double
        let pricePerUnit: Double
        let closed: String
        
        enum OrderType: String {
            case sell
            case buy
            case unknown
        }
        
        var orderType: OrderType {
            switch type {
            case "MARKET_SELL":
                return .sell
            case "MARKET_BUY":
                return .buy
            default:
                return .unknown
            }
        }
    }
}
