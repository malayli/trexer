//
//  BalancesTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer
import Combine

final class BalancesTests: XCTestCase {
    func testBalancesDecoding() {
        guard let balances = try? JSONDecoder().decode([Balance].self, from: Parser.load("balances.json")) else {
            XCTFail("testBalancesDecoding fails")
            return
        }
        XCTAssertEqual(balances.count, 3)
    }
    
    func testBalancesParsing() {
        let expectation = XCTestExpectation(description: "")
        
        let data = Parser.load("balances.json")
        
        let publisher: AnyPublisher<[Balance], BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (balances) in
            XCTAssertEqual(balances.count, 3)
            XCTAssertEqual(balances.first?.currencySymbol, "BTC")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testBalanceRowViewModel() {
        guard let balances = try? JSONDecoder().decode([Balance].self, from: Parser.load("balances.json")) else {
            XCTFail("testBalanceRowViewModel fails")
            return
        }
        let balanceRowViewModel1 = BalanceRowViewModel(item: balances[0])
        XCTAssertEqual(balanceRowViewModel1.id, "BTC")
        
        let balanceRowViewModel2 = BalanceRowViewModel(item: balances[1])
        XCTAssertEqual(balanceRowViewModel2.id, "MONA")
        
        XCTAssertNotEqual(balanceRowViewModel1, balanceRowViewModel2)
    }
    
    func testBalancesViewModel() {
        let expectation = XCTestExpectation(description: "testBalancesViewModel")
        
        let container = DependenciesContainerMock()
        guard let viewModel: BalancesViewModel = container.resolve(BalancesViewModel.self) else {
            XCTFail("testBalancesDecoding fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(viewModel.dataSource.count, 3)
            XCTAssertEqual(viewModel.dataSource.first?.id, "BTC")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
