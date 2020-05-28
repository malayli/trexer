//
//  MarketsViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI
import Combine

protocol BittrexProviding {
    func fetch(completion: @escaping () -> Void) -> AnyCancellable
    func refresh()
}

final class MarketsViewModel: ObservableObject, Identifiable {
    private let marketsListProvider: BittrexFetching
    private let bitcoinProvider: BittrexFetching
    private var disposables = Set<AnyCancellable>()
    @Published var currency: Currency?
    @Published var dataSource: [MarketRowViewModel] = []
    
    init(marketsListProvider: BittrexFetching, bitcoinProvider: BittrexFetching) {
        self.marketsListProvider = marketsListProvider
        self.bitcoinProvider = bitcoinProvider
    }
    
    func index(for name: String) -> Int {
        dataSource.lastIndex { (marketRowViewModel) -> Bool in
            marketRowViewModel.name == name
        } ?? 0
    }
}

extension MarketsViewModel: BittrexProviding {
    func fetch(completion: @escaping () -> Void) -> AnyCancellable {
        Publishers.Zip(bitcoinProvider.bitcoin(), marketsListProvider.markets())
        .map { (currency, response) -> (Currency, [MarketRowViewModel]) in
            (currency, response.result.sorted { (m1, m2) -> Bool in
                return m1.rate < m2.rate
            }.map { MarketRowViewModel(item: $0) })
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                self.currency = nil
                self.dataSource = []
            case .finished: ()
            }
            
        }, receiveValue: { [weak self] (currency, marketRowViewModels) in
            guard let self = self else { return }
            self.currency = currency
            self.dataSource = marketRowViewModels
            completion()
        })
    }
    
    func refresh() {
        fetch(completion: {}).store(in: &disposables)
    }
}
