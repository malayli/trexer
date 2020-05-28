//
//  MarketSummary.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

//{"MarketName":"BTC-HYC","High":0.00000023,"Low":0.00000020,"Volume":93439.44707331,"Last":0.00000022,"BaseVolume":0.02022940,"TimeStamp":"2020-05-28T11:13:01.747","Bid":0.00000022,"Ask":0.00000023,"OpenBuyOrders":29,"OpenSellOrders":40,"PrevDay":0.00000020,"Created":"2019-12-03T00:00:33.09"}

struct Markets: Codable {
    let result: [Summary]
    
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
        let high: Double?
        let low: Double?
        let volume: Double?
        let last: Double?
        let baseVolume: Double?
        let timeStamp: String
        let bid: Double?
        let ask: Double?
        let openBuyOrders: Int?
        let openSellOrders: Int?
        let prevDay: Double?
        let created: String
    }
}

extension Markets.Summary: Identifiable {
    var id: String {
        marketName
    }
}

extension Markets.Summary {
    var rate: Double {
        guard let last = last, let prevDay = prevDay, prevDay > 0.0 else {
            return 0.0
        }
        return ((last / prevDay) - 1) * 100.0
    }
}
