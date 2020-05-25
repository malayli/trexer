//
//  MarketsView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct MarketsView: View {
    @ObservedObject var marketsViewModel: MarketsViewModel
    @State private var searchText : String = ""
    
    init?(container: Container<Any>) {
        guard let viewModel: MarketsViewModel = container.resolve(MarketsViewModel.self) else {
            return nil
        }
        marketsViewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    if marketsViewModel.dataSource.count == 0 {
                        LoadingView()
                        
                    } else {
                        ForEach(marketsViewModel.dataSource.filter {
                            searchText.isEmpty ? true : $0.name.contains(searchText.uppercased())
                        }) { rowViewModel in
                            NavigationLink(destination: MarketDetailView(marketRowViewModel: rowViewModel, currencyViewModel: CurrencyViewModel(item: self.marketsViewModel.currency!))) {
                                MarketRowView(marketRowViewModel: rowViewModel, currencyViewModel: CurrencyViewModel(item: self.marketsViewModel.currency!))
                            }
                        }
                    }
                }
                .navigationBarTitle("Markets", displayMode: .inline)
                .onAppear(perform: marketsViewModel.refresh)
            }
        }
    }
}
