//
//  MarketSummary.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct Markets: Codable {
    var result: [MarketInfo]
    
    struct MarketInfo: Codable {
        enum CodingKeys: String, CodingKey {
            case market = "Market"
            case summary = "Summary"
        }
        
        let market: Market
        let summary: Summary
        
        struct Market: Codable {
            enum CodingKeys: String, CodingKey {
                case MarketCurrency
                case BaseCurrency
                case MarketCurrencyLong
                case BaseCurrencyLong
                case MinTradeSize
                case MarketName
                case logoUrl = "LogoUrl"
            }
            
            let MarketCurrency: String
            let BaseCurrency: String
            let MarketCurrencyLong: String
            let BaseCurrencyLong: String
            let MinTradeSize: Double
            let MarketName: String
            let logoUrl: String
        }
        
        struct Summary: Codable {
            enum CodingKeys: String, CodingKey {
                case marketName = "MarketName"
                case High
                case Low
                case Volume
                case last = "Last"
                case baseVolume = "BaseVolume"
                case TimeStamp
                case Bid
                case Ask
                case OpenBuyOrders
                case OpenSellOrders
                case prevDay = "PrevDay"
                case Created
            }
            
            let marketName: String
            let High: Double
            let Low: Double
            let Volume: Double
            let last: Double
            let baseVolume: Double
            let TimeStamp: String
            let Bid: Double
            let Ask: Double
            let OpenBuyOrders: Int
            let OpenSellOrders: Int
            let prevDay: Double
            let Created: String
        }
    }
}

extension Markets.MarketInfo: Identifiable {
    var id: String {
        summary.marketName
    }
}
