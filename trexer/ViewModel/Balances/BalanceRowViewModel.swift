//
//  BalanceRowViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct BalanceRowViewModel {
    let item: Balance
}

extension BalanceRowViewModel: Identifiable {
    var id: String {
        item.currencySymbol
    }
}

extension BalanceRowViewModel: Equatable {
    static func == (lhs: BalanceRowViewModel, rhs: BalanceRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
