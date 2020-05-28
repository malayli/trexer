//
//  DependenciesContainer.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

final class DependenciesContainer: Container<Any> {
    override init() {
        super.init()
        let provider = BittrexProvider(URLSession.shared,
                                       apiKey: Credentials.apiKey,
                                       secretKey: Credentials.secretKey)
        
        let marketsViewModel = MarketsViewModel(marketsListProvider: provider, bitcoinProvider: provider, currenciesProvider: provider)
        let ordersViewModel = OrdersViewModel(provider: provider)
        let balancesViewModel = BalancesViewModel(provider: provider)
        
        register(marketsViewModel)
        register(ordersViewModel)
        register(balancesViewModel)
    }
}
