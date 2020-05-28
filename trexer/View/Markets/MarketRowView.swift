//
//  MarketRowView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct MarketRowView: View {
    let marketRowViewModel: MarketRowViewModel
    let tickerViewModel: TickerViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(marketRowViewModel.name)")
                Text("\("last".localized): \(marketRowViewModel.last) \(marketRowViewModel.currencySymbol)")
            }
            marketRowViewModel.rateText.frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct MarketRowView_Previews: PreviewProvider {
    static var previews: some View {
        let jsonDecoder = JSONDecoder()
        
        let markets = try? jsonDecoder.decode(Markets.self, from: Parser.load("market.json"))
        let marketRowViewModel1 = MarketRowViewModel(item: markets!.result[0], currency: nil)
        let marketRowViewModel2 = MarketRowViewModel(item: markets!.result[1], currency: nil)
        
        let ticker = try? jsonDecoder.decode(Ticker.self, from: Parser.load("ticker.json"))
        let tickerViewModel: TickerViewModel = TickerViewModel(item: ticker)
        
        return Group {
            MarketRowView(marketRowViewModel: marketRowViewModel1, tickerViewModel: tickerViewModel)
            MarketRowView(marketRowViewModel: marketRowViewModel2, tickerViewModel: tickerViewModel)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
