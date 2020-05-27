//
//  OrderRowViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

struct OrderRowViewModel {
    let item: Orders.Order
}

extension OrderRowViewModel {
    var name: String {
        return item.exchange
    }
    
    var orderType: Orders.Order.OrderType {
        return item.orderType
    }
}

extension OrderRowViewModel: Identifiable {
    var id: String {
        return item.orderUuid
    }
}

extension OrderRowViewModel: Equatable {
    static func == (lhs: OrderRowViewModel, rhs: OrderRowViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
