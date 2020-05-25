//
//  CurrencyTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer
import Combine

final class CurrencyTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCurrencyDecoding() {
        let currency = try? JSONDecoder().decode(Currency.self, from: Parser.load("bitcoin.json"))
        XCTAssertEqual(currency?.result.bpi.USD.rateFloat, 8998.974)
    }
    
    func testCurrencyParsing() {
        let data = Parser.load("bitcoin.json")
        let publisher: AnyPublisher<Currency, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (bitcoin) in
            XCTAssertEqual(bitcoin.result.bpi.USD.rateFloat, 8998.974)
        }
    }

    func testPerformanceCurrencyParsing() {
        // Bitcoin Parsing performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testCurrencyParsing()
        }
    }
}
