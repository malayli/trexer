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
        guard array.count == 2 else {
            return ""
        }
        let renamed = "\(array[1])-\(array[0])"
        return renamed
    }
    
    var orderType: Order.OrderType {
        item.orderType
    }
    
    var price: Double {
        Double(item.proceeds) ?? 0.0
    }
    
    var pricePerUnit: Double {
        var pricePerUnit: Double = 0.0
        if let proceeds = Double(item.proceeds),
            let quantity = Double(item.quantity) {
            pricePerUnit = proceeds / quantity
        }
        return pricePerUnit
    }
    
    var quantity: String {
        item.quantity
    }
}

extension OrderRowViewModel: Identifiable {
    var id: String {
        item.id
    }
}

extension OrderRowViewModel: Equatable {
    static func == (lhs: OrderRowViewModel, rhs: OrderRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
