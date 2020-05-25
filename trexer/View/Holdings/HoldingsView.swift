//
//  HoldingsView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct HoldingsView: View {
    @ObservedObject var balancesViewModel: BalancesViewModel
    @State private var searchText : String = ""
    
    init?(container: Container<Any>) {
        guard let viewModel: BalancesViewModel = container.resolve(BalancesViewModel.self) else {
            return nil
        }
        balancesViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    if balancesViewModel.dataSource.count == 0 {
                        LoadingView()
                        
                    } else {
                        ForEach(balancesViewModel.dataSource.filter {
                            searchText.isEmpty ? true : $0.id.contains(searchText.uppercased())
                        }) { rowViewModel in
                            BalanceRowView(balanceRowViewModel: rowViewModel)
                        }
                    }
                }
                .navigationBarTitle("Holdings", displayMode: .inline)
                .onAppear(perform: balancesViewModel.refresh)
            }
        }
    }
}
