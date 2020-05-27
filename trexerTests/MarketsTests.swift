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
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testMarketsDecoding() {
        guard let markets = try? JSONDecoder().decode(Markets.self, from: Parser.load("market.json")) else {
            assertionFailure("testMarketsDecoding fails")
            return
        }
        XCTAssertEqual(markets.result.count, 184)
        XCTAssertEqual(markets.result.first?.id, "BTC-RVN")
    }
    
    func testMarketsParsing() {
        let data = Parser.load("market.json")
        
        let publisher: AnyPublisher<Markets, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (marketsLits) in
            XCTAssertEqual(marketsLits.result.count, 184)
            XCTAssertEqual(marketsLits.result.first?.id, "BTC-RVN")
        }
    }
    
    func testMarketRowViewModel() {
        guard let markets = try? JSONDecoder().decode(Markets.self, from: Parser.load("market.json")) else {
            assertionFailure("testMarketRowViewModel fails")
            return
        }
        let rowViewModel1 = MarketRowViewModel(item: markets.result[0])
        XCTAssertEqual(rowViewModel1.id, "BTC-RVN")
        
        let rowViewModel2 = MarketRowViewModel(item: markets.result[1])
        XCTAssertEqual(rowViewModel2.id, "USD-ZEN")
        
        XCTAssertNotEqual(rowViewModel1, rowViewModel2)
    }
    
    func testMarketsViewModel() {
        let container = DependenciesContainerMock()
        guard let viewModel: MarketsViewModel = container.resolve(MarketsViewModel.self) else {
            assertionFailure("testMarketsViewModel fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(CurrencyViewModel(item: viewModel.currency!).value, 8998.974)
            XCTAssertEqual(viewModel.dataSource.count, 184)
            XCTAssertEqual(viewModel.dataSource.first?.id, "BTC-GEO")
        }
    }
    
    func testPerformanceMarketsListParsing() {
        // MarketsData List Parsing performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testMarketsParsing()
        }
    }
}
