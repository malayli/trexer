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
    private let currency: Currency?
    private var disposables = Set<AnyCancellable>()
    
    init(item: Markets.Summary, currency: Currency?) {
        self.item = item
        self.currency = currency
    }
}

extension MarketRowViewModel {
    var name: String {
        item.marketName
    }
    
    var currencySymbol: String {
        let array = name.components(separatedBy: "-")
        
        if array[0] == "USD" {
            return "$"
            
        } else if array[0] == "BTC" {
            return "₿"
            
        } else {
            return array[0]
        }
    }
    
    var logoURL: URL? {
        guard let urlString = currency?.logoUrl else {
            return nil
        }
        return URL(string: urlString)
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
