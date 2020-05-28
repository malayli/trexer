//
//  MarketsTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer
import Combine

final class MarketsTests: XCTestCase {
    func testMarketsDecoding() {
        do {
            let markets = try JSONDecoder().decode(Markets.self, from: Parser.load("market.json"))
            XCTAssertEqual(markets.result.count, 441)
            XCTAssertEqual(markets.result.first?.id, "BTC-HYC")
            
        } catch {
            print(error)
            XCTFail("testMarketRowViewModel fails")
        }
    }
    
    func testMarketsParsing() {
        let expectation = XCTestExpectation(description: "")
        
        let data = Parser.load("market.json")
        
        let publisher: AnyPublisher<Markets, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (marketsLits) in
            XCTAssertEqual(marketsLits.result.count, 441)
            XCTAssertEqual(marketsLits.result.first?.id, "BTC-HYC")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testMarketRowViewModel() {
        do {
            let markets = try JSONDecoder().decode(Markets.self, from: Parser.load("market.json"))
            
            let rowViewModel1 = MarketRowViewModel(item: markets.result[0], currency: nil)
            XCTAssertEqual(rowViewModel1.id, "BTC-HYC")
            
            let rowViewModel2 = MarketRowViewModel(item: markets.result[1], currency: nil)
            XCTAssertEqual(rowViewModel2.id, "ETH-ENG")
            
            XCTAssertNotEqual(rowViewModel1, rowViewModel2)
            
        } catch {
            print(error)
            XCTFail("testMarketRowViewModel fails")
        }
    }
    
    func testMarketsViewModel() {
        let expectation = XCTestExpectation(description: "testMarketsViewModel")
        
        let container = DependenciesContainerMock()
        guard let viewModel: MarketsViewModel = container.resolve(MarketsViewModel.self) else {
            XCTFail("testMarketsViewModel fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(TickerViewModel(item: viewModel.ticker).value, 9465.952)
            XCTAssertEqual(viewModel.dataSource.count, 441)
            XCTAssertEqual(viewModel.dataSource.first?.id, "BTC-VID")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
