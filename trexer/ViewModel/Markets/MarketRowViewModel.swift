//
//  MarketRowViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI
import Combine

struct MarketRowViewModel {
    private let item: Markets.MarketInfo
    private var disposables = Set<AnyCancellable>()
    
    init(item: Markets.MarketInfo) {
        self.item = item
    }
}

extension MarketRowViewModel {
    var name: String {
        item.summary.marketName
    }
    
    var currency: String {
        let array = name.components(separatedBy: "-")
        
        if array[0] == "USD" {
            return "$"
            
        } else if array[0] == "BTC" {
            return "₿"
            
        } else {
            return array[0]
        }
    }
    
    var baseVolume: Double {
        item.summary.baseVolume
    }
    
    var prevDay: Double {
        item.summary.prevDay
    }
    
    var last: Double {
        item.summary.last
    }
    
    var logoURL: URL? {
        URL(string: item.market.logoUrl)
    }
    
    var rate: Double {
        -(1 - (last / prevDay)) * 100.0
    }
    
    var rateText: Text {
        Text((rate > 0 ? "+" : "") + String(format: "%.2f", rate) + "%").foregroundColor(rate < 0 ? .red : .green)
    }
}

extension MarketRowViewModel: Identifiable {
    var id: String {
        item.summary.marketName
    }
}

extension MarketRowViewModel: Equatable {
    static func == (lhs: MarketRowViewModel, rhs: MarketRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
