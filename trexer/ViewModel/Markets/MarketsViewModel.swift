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
            (currency, response.result
            .sorted { (m1, m2) -> Bool in
                m1.summary.last / m1.summary.prevDay < m2.summary.last / m2.summary.prevDay
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
