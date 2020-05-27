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
        return item.currencySymbol
    }
}

extension BalanceRowViewModel: Equatable {
    static func == (lhs: BalanceRowViewModel, rhs: BalanceRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
