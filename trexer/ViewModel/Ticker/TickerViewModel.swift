//
//  TickerViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct TickerViewModel {
    private let item: Ticker?
    
    init(item: Ticker?) {
        self.item = item
    }
}

extension TickerViewModel {
    var value: Double {
        item?.result.last ?? 0.0
    }
}
