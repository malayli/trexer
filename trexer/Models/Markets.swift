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
                case marketCurrency = "MarketCurrency"
                case baseCurrency = "BaseCurrency"
                case marketCurrencyLong = "MarketCurrencyLong"
                case baseCurrencyLong = "BaseCurrencyLong"
                case minTradeSize = "MinTradeSize"
                case marketName = "MarketName"
                case logoUrl = "LogoUrl"
            }
            
            let marketCurrency: String
            let baseCurrency: String
            let marketCurrencyLong: String
            let baseCurrencyLong: String
            let minTradeSize: Double
            let marketName: String
            let logoUrl: String
        }
        
        struct Summary: Codable {
            enum CodingKeys: String, CodingKey {
                case marketName = "MarketName"
                case high = "High"
                case low = "Low"
                case volume = "Volume"
                case last = "Last"
                case baseVolume = "BaseVolume"
                case timeStamp = "TimeStamp"
                case bid = "Bid"
                case ask = "Ask"
                case openBuyOrders = "OpenBuyOrders"
                case openSellOrders = "OpenSellOrders"
                case prevDay = "PrevDay"
                case created = "Created"
            }
            
            let marketName: String
            let high: Double
            let low: Double
            let volume: Double
            let last: Double
            let baseVolume: Double
            let timeStamp: String
            let bid: Double
            let ask: Double
            let openBuyOrders: Int
            let openSellOrders: Int
            let prevDay: Double
            let created: String
        }
    }
}

extension Markets.MarketInfo: Identifiable {
    var id: String {
        summary.marketName
    }
}
