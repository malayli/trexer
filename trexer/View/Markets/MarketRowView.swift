//
//  MarketRowView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct MarketRowView: View {
    let marketRowViewModel: MarketRowViewModel
    let currencyViewModel: CurrencyViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(marketRowViewModel.name)")
                Text("\("last".localized): \(marketRowViewModel.last) \(marketRowViewModel.currency)")
            }
            marketRowViewModel.rateText.frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct MarketRowView_Previews: PreviewProvider {
    static var previews: some View {
        let jsonDecoder = JSONDecoder()
        
        let markets = try? jsonDecoder.decode(Markets.self, from: Parser.load("market.json"))
        
        let currency = try? jsonDecoder.decode(Currency.self, from: Parser.load("bitcoin.json"))
        let currencyViewModel: CurrencyViewModel = CurrencyViewModel(item: currency!)
        
        let marketRowViewModel1 = MarketRowViewModel(item: markets!.result[0])
        
        let marketRowViewModel2 = MarketRowViewModel(item: markets!.result[1])
        
        return Group {
            MarketRowView(marketRowViewModel: marketRowViewModel1, currencyViewModel: currencyViewModel)
            MarketRowView(marketRowViewModel: marketRowViewModel2, currencyViewModel: currencyViewModel)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
