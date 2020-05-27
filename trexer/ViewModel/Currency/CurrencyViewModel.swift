//
//  CurrencyViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct CurrencyViewModel {
    private let item: Currency
    
    init(item: Currency) {
        self.item = item
    }
}

extension CurrencyViewModel {
    var value: Double {
        return item.result.bpi.USD.rateFloat
    }
}
