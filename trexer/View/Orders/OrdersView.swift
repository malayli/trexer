//
//  OrdersView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var ordersViewModel: OrdersViewModel
    @ObservedObject var marketsViewModel: MarketsViewModel
    @State private var searchText: String = ""
    
    init?(container: Container<Any>) {
        guard let ordersVM: OrdersViewModel = container.resolve(OrdersViewModel.self),
            let marketsVM: MarketsViewModel = container.resolve(MarketsViewModel.self) else {
            return nil
        }
        ordersViewModel = ordersVM
        marketsViewModel = marketsVM
    }
    
    private func marketDetailView(_ rowViewModel: OrderRowViewModel) -> MarketDetailView {
        let index = marketsViewModel.index(for: rowViewModel.name)
        
        return MarketDetailView(marketRowViewModel: marketsViewModel.dataSource[index], tickerViewModel: TickerViewModel(item: marketsViewModel.ticker))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, placeholder: "Search")
                List {
                    if ordersViewModel.dataSource.count == 0 {
                        LoadingView()
                        
                    } else {
                        ForEach(ordersViewModel.dataSource.filter {
                            searchText.isEmpty ? true : $0.name.contains(searchText.uppercased())
                        }) { rowViewModel in
                            NavigationLink(destination: self.marketDetailView(rowViewModel)) {
                                OrderRowView(orderRowViewModel: rowViewModel, todayPricePerUnit: self.marketsViewModel.dataSource[self.marketsViewModel.index(for: rowViewModel.name)].last)
                            }
                        }
                    }
                }
                .navigationBarTitle("Orders", displayMode: .inline)
                .onAppear(perform: ordersViewModel.refresh)
            }
        }
    }
}
