//
//  OrderRowView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct OrderRowView: View {
    let orderRowViewModel: OrderRowViewModel
    let todayPricePerUnit: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(orderRowViewModel.name)")
            Text("Price: \(orderRowViewModel.item.price)")
            Text("Price per unit: \(orderRowViewModel.item.pricePerUnit)")
            if orderRowViewModel.orderType == .buy {
                Text("Today's Price per unit: \(todayPricePerUnit)")
            }
            Text("Quantity: \(orderRowViewModel.item.quantity)")
            Text("Type: \(orderRowViewModel.orderType.rawValue)").foregroundColor(orderRowViewModel.orderType == .buy ? .green : .red)
        }
    }
}

struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        let orders = try! JSONDecoder().decode(Orders.self, from: Parser.load("orders.json"))
        return OrderRowView(orderRowViewModel: OrderRowViewModel(item: orders.result.first!), todayPricePerUnit: 0.0)
    }
}
