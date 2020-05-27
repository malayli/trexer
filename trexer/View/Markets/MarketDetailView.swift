//
//  MarketDetailView.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import SwiftUI

struct MarketDetailView: View {
    let marketRowViewModel: MarketRowViewModel
    let currencyViewModel: CurrencyViewModel
    private let webPageURLString = "https://global.bittrex.com/Market/Index?MarketName="
    
    var body: some View {
        Group {
            VStack(alignment: .center, spacing: 10) {
                AsyncImage(
                    url: marketRowViewModel.logoURL,
                    
                    placeholder: ActivityIndicator().frame(width: 80.0, height: 80.0, alignment: .center).foregroundColor(.orange)
                    
                ).aspectRatio(contentMode: .fit).frame(width: 80.0, height: 80.0, alignment: .center)
                
                Text("\(marketRowViewModel.name)").font(.largeTitle)
                
                marketRowViewModel.rateText.font(.largeTitle)
            }.padding(.top, 20)
            
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("last".localized + ":")
                        Text("24h ago:")
                        if marketRowViewModel.name.starts(with: "BTC") {
                            Text("Last value:")
                            Text("24h ago value:")
                        }
                        Text("24h volume:")
                    }
                    VStack(alignment: .leading) {
                        Text("\(marketRowViewModel.last) \(marketRowViewModel.currency)")
                        .font(.headline)
                        Text("\(marketRowViewModel.prevDay) \(marketRowViewModel.currency)")
                        .font(.headline)
                        if marketRowViewModel.name.starts(with: "BTC") {
                            Text("\(marketRowViewModel.last * currencyViewModel.value) $")
                            .font(.headline)
                            Text("\(marketRowViewModel.prevDay * currencyViewModel.value) $")
                            .font(.headline)
                        }
                        Text("\(marketRowViewModel.baseVolume) \(marketRowViewModel.currency)")
                        .font(.headline)
                    }
                }
                
                Button(action: {
                    guard let url = URL(string: "\(self.webPageURLString)\(self.marketRowViewModel.name)") else {
                        return
                    }
                    UIApplication.shared.open(url)
                    
                }) { () -> Text in
                    Text("Open web page")
                }
                
            }.padding(.top, 20)
            
            Spacer()
        }
    }
}

struct MarketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let jsonDecoder = JSONDecoder()
        
        let markets = try? jsonDecoder.decode(Markets.self, from: Parser.load("market.json"))
        let marketRowViewModel = MarketRowViewModel(item: markets!.result.first!)
        
        let currency = try? jsonDecoder.decode(Currency.self, from: Parser.load("bitcoin.json"))
        let currencyViewModel: CurrencyViewModel = CurrencyViewModel(item: currency!)
        
        return MarketDetailView(marketRowViewModel: marketRowViewModel, currencyViewModel: currencyViewModel)
    }
}
