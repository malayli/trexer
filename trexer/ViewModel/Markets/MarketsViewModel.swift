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
    private let currenciesProvider: BittrexFetching
    private var disposables = Set<AnyCancellable>()
    @Published var currencies: [Currency]?
    @Published var ticker: Ticker?
    @Published var dataSource: [MarketRowViewModel] = []
    
    init(marketsListProvider: BittrexFetching,
         bitcoinProvider: BittrexFetching,
         currenciesProvider: BittrexFetching) {
        self.marketsListProvider = marketsListProvider
        self.bitcoinProvider = bitcoinProvider
        self.currenciesProvider = currenciesProvider
    }
    
    func index(for name: String) -> Int {
        dataSource.lastIndex { (marketRowViewModel) -> Bool in
            marketRowViewModel.name == name
        } ?? 0
    }
}

extension MarketsViewModel: BittrexProviding {
    func fetch(completion: @escaping () -> Void) -> AnyCancellable {
        Publishers.Zip3(currenciesProvider.currencies(), bitcoinProvider.bitcoin(), marketsListProvider.markets()).map {
            ($0, $1, $2.result.sorted(by: { (m1, m2) -> Bool in
                m1.rate < m2.rate
            }).map { item -> MarketRowViewModel in
                let array = item.marketName.components(separatedBy: "-")
                
                return MarketRowViewModel(item: item, currency: self.currencies?.first(where: {
                    array[1].contains($0.symbol)
                }))
            })
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                self.currencies = nil
                self.ticker = nil
                self.dataSource = []
            case .finished: ()
            }
            
        }, receiveValue: { [weak self] (curencies, ticker, marketRowViewModels) in
            guard let self = self else { return }
            self.currencies = curencies
            self.ticker = ticker
            self.dataSource = marketRowViewModels
            completion()
        })
    }
    
    func refresh() {
        fetch(completion: {}).store(in: &disposables)
    }
}
