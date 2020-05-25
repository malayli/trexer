//
//  DependenciesContainerMock.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation

final class DependenciesContainerMock: Container<Any> {
    override init() {
        super.init()
        
        let marketsListProvider = BittrexProviderMock(data: Parser.load("market.json"))
        let bitcoinProvider = BittrexProviderMock(data: Parser.load("bitcoin.json"))
        let ordersProvider = BittrexProviderMock(data: Parser.load("orders.json"))
        let balancesProvider = BittrexProviderMock(data: Parser.load("balances.json"))
        
        let marketsViewModel = MarketsViewModel(marketsListProvider: marketsListProvider, bitcoinProvider: bitcoinProvider)
        let ordersViewModel = OrdersViewModel(provider: ordersProvider)
        let balancesViewModel = BalancesViewModel(provider: balancesProvider)
        
        register(marketsViewModel)
        register(ordersViewModel)
        register(balancesViewModel)
    }
}
