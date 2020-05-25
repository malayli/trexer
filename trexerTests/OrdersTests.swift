//
//  OrdersTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer
import Combine

final class OrdersTests: XCTestCase {
    func testOrdersDecoding() {
        guard let orders = try? JSONDecoder().decode(Orders.self, from: Parser.load("orders.json")) else {
            assertionFailure("testOrdersDecoding fails")
            return
        }
        XCTAssertEqual(orders.result.count, 3)
        XCTAssertEqual(orders.result[0].orderType, .buy)
        XCTAssertEqual(orders.result[1].orderType, .sell)
        XCTAssertEqual(orders.result[2].orderType, .unknown)
    }
    
    func testOrdersParsing() {
        let data = Parser.load("orders.json")
        
        let publisher: AnyPublisher<Orders, BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (orders) in
            XCTAssertEqual(orders.result.count, 3)
            XCTAssertEqual(orders.result.first?.exchange, "BTC-ETH")
            XCTAssertEqual(orders.result.first?.orderType, .buy)
        }
    }
    
    func testOrderRowViewModel() {
        guard let orders = try? JSONDecoder().decode(Orders.self, from: Parser.load("orders.json")) else {
            assertionFailure("testOrderRowViewModel fails")
            return
        }
        let rowViewModel1 = OrderRowViewModel(item: orders.result[0])
        XCTAssertEqual(rowViewModel1.id, "abcd-efgh-ijkl-mnop-pqrs1234")
        
        let rowViewModel2 = OrderRowViewModel(item: orders.result[1])
        XCTAssertEqual(rowViewModel2.id, "abcd-efgh-ijkl-mnop-pqrs5678")
        
        XCTAssertNotEqual(rowViewModel1, rowViewModel2)
    }
    
    func testOrdersViewModel() {
        let container = DependenciesContainerMock()
        guard let viewModel: OrdersViewModel = container.resolve(OrdersViewModel.self) else {
            assertionFailure("testOrdersViewModel fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(viewModel.dataSource.count, 3)
            XCTAssertEqual(viewModel.dataSource.first?.name, "BTC-ETH")
            XCTAssertEqual(viewModel.dataSource.first?.orderType, .buy)
        }
    }
}
