//
//  OrderRowViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct OrderRowViewModel {
    let item: Order
}

extension OrderRowViewModel {
    var name: String {
        let array = item.marketSymbol.components(separatedBy: "-")
        let renamed = "\(array[1])-\(array[0])"
        return renamed
    }
    
    var orderType: Order.OrderType {
        return item.orderType
    }
}

extension OrderRowViewModel: Identifiable {
    var id: String {
        return item.id
    }
}

extension OrderRowViewModel: Equatable {
    static func == (lhs: OrderRowViewModel, rhs: OrderRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
