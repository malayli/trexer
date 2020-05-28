//
//  MarketRowViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI
import Combine

struct MarketRowViewModel {
    private let item: Markets.Summary
    private var disposables = Set<AnyCancellable>()
    
    init(item: Markets.Summary) {
        self.item = item
    }
}

extension MarketRowViewModel {
    var name: String {
        item.marketName
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
        item.baseVolume ?? 0.0
    }
    
    var prevDay: Double {
        item.prevDay ?? 0.0
    }
    
    var last: Double {
        item.last ?? 0.0
    }
    
    var logoURL: URL? {
        URL(string: "")
    }
    
    var rateText: Text {
        Text((item.rate > 0 ? "+" : "") + String(format: "%.2f", item.rate) + "%").foregroundColor(item.rate < 0 ? .red : .green)
    }
}

extension MarketRowViewModel: Identifiable {
    var id: String {
        item.marketName
    }
}

extension MarketRowViewModel: Equatable {
    static func == (lhs: MarketRowViewModel, rhs: MarketRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
