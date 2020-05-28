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
        do {
            let markets = try JSONDecoder().decode(Markets.self, from: Parser.load("market.json"))
            XCTAssertEqual(markets.result.count, 441)
            XCTAssertEqual(markets.result.first?.id, "BTC-HYC")
            
        } catch {
            print(error)
            assertionFailure("testMarketRowViewModel fails")
        }
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
            XCTAssertEqual(marketsLits.result.count, 441)
            XCTAssertEqual(marketsLits.result.first?.id, "BTC-HYC")
        }
    }
    
    func testMarketRowViewModel() {
        do {
            let markets = try JSONDecoder().decode(Markets.self, from: Parser.load("market.json"))
            
            let rowViewModel1 = MarketRowViewModel(item: markets.result[0])
            XCTAssertEqual(rowViewModel1.id, "BTC-HYC")
            
            let rowViewModel2 = MarketRowViewModel(item: markets.result[1])
            XCTAssertEqual(rowViewModel2.id, "ETH-ENG")
            
            XCTAssertNotEqual(rowViewModel1, rowViewModel2)
            
        } catch {
            print(error)
            assertionFailure("testMarketRowViewModel fails")
        }
    }
    
    func testMarketsViewModel() {
        let expectation = XCTestExpectation(description: "testMarketsViewModel")
        
        let container = DependenciesContainerMock()
        guard let viewModel: MarketsViewModel = container.resolve(MarketsViewModel.self) else {
            assertionFailure("testMarketsViewModel fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(CurrencyViewModel(item: viewModel.currency!).value, 9465.952)
            XCTAssertEqual(viewModel.dataSource.count, 441)
            XCTAssertEqual(viewModel.dataSource.first?.id, "BTC-VID")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
