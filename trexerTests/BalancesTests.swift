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
        guard let balances = try? JSONDecoder().decode(Balances.self, from: Parser.load("balances.json")) else {
            assertionFailure("testBalancesDecoding fails")
            return
        }
        XCTAssertEqual(balances.result.count, 3)
    }
    
    func testBalancesParsing() {
        let data = Parser.load("balances.json")
        
        let publisher: AnyPublisher<Balances, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (balances) in
            XCTAssertEqual(balances.result.count, 3)
            XCTAssertEqual(balances.result.first?.currency, "BTC")
        }
    }
    
    func testBalanceRowViewModel() {
        guard let balances = try? JSONDecoder().decode(Balances.self, from: Parser.load("balances.json")) else {
            assertionFailure("testBalanceRowViewModel fails")
            return
        }
        let balanceRowViewModel1 = BalanceRowViewModel(item: balances.result[0])
        XCTAssertEqual(balanceRowViewModel1.id, "BTC")
        
        let balanceRowViewModel2 = BalanceRowViewModel(item: balances.result[1])
        XCTAssertEqual(balanceRowViewModel2.id, "MONA")
        
        XCTAssertNotEqual(balanceRowViewModel1, balanceRowViewModel2)
    }
    
    func testBalancesViewModel() {
        let container = DependenciesContainerMock()
        guard let viewModel: BalancesViewModel = container.resolve(BalancesViewModel.self) else {
            assertionFailure("testBalancesDecoding fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(viewModel.dataSource.count, 3)
            XCTAssertEqual(viewModel.dataSource.first?.id, "BTC")
        }
    }
}
