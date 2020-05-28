//
//  TickerTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer
import Combine

final class TickerTests: XCTestCase {
    func testTickerDecoding() {
        let currency = try? JSONDecoder().decode(Ticker.self, from: Parser.load("ticker.json"))
        XCTAssertEqual(currency?.result.last, 9465.952)
    }
    
    func testTickerParsing() {
        let data = Parser.load("ticker.json")
        let publisher: AnyPublisher<Ticker, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (bitcoin) in
            XCTAssertEqual(bitcoin.result.last, 9465.952)
        }
    }

    func testPerformanceTickerParsing() {
        // Bitcoin Parsing performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testTickerParsing()
        }
    }
}
