//
//  BalancesViewModel.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI
import Combine

final class BalancesViewModel: ObservableObject {
    private let provider: BittrexFetching
    private var disposables = Set<AnyCancellable>()
    @Published var dataSource: [BalanceRowViewModel] = []
    
    init(provider: BittrexFetching) {
        self.provider = provider
    }
}

extension BalancesViewModel: BittrexProviding {
    func fetch(completion: @escaping () -> Void) -> AnyCancellable {
        provider.balances()
        .map {
            $0.filter {
                Double($0.total) ?? 0 > 0
            }.map(BalanceRowViewModel.init)
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .failure:
                self.dataSource = []
            case .finished: ()
            }
            
        }, receiveValue: { [weak self] (rowViewModels) in
            guard let self = self else { return }
            self.dataSource = rowViewModels
            completion()
        })
    }
    
    func refresh() {
        fetch(completion: {}).store(in: &disposables)
    }
}
