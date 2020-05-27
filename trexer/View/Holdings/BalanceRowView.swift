//
//  BalanceRowView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct BalanceRowView: View {
    let balanceRowViewModel: BalanceRowViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(balanceRowViewModel.item.currencySymbol)")
            Text("Balance: \(balanceRowViewModel.item.total)")
        }
    }
}

struct BalanceRowView_Previews: PreviewProvider {
    static var previews: some View {
        let balances = try! JSONDecoder().decode([Balance].self, from: Parser.load("balances.json"))
        return BalanceRowView(balanceRowViewModel: BalanceRowViewModel(item: balances[0]))
    }
}
