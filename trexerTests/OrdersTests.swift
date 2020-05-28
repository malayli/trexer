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
        guard let orders = try? JSONDecoder().decode([Order].self, from: Parser.load("orders.json")) else {
            XCTFail("testOrdersDecoding fails")
            return
        }
        XCTAssertEqual(orders.count, 3)
        XCTAssertEqual(orders[0].orderType, .buy)
        XCTAssertEqual(orders[1].orderType, .sell)
        XCTAssertEqual(orders[2].orderType, .buy)
    }
    
    func testOrdersParsing() {
        let expectation = XCTestExpectation(description: "")
        
        let data = Parser.load("orders.json")
        
        let publisher: AnyPublisher<[Order], BittrexError> = Parser.decode(data)
        
        _ = publisher.sink(receiveCompletion: { (error) in
            switch error {
            case .failure:
                XCTFail()
            case .finished: ()
            }
            
        }) { (orders) in
            XCTAssertEqual(orders.count, 3)
            XCTAssertEqual(orders[0].marketSymbol, "DGB-BTC")
            XCTAssertEqual(orders[0].orderType, .buy)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testOrderRowViewModel() {
        guard let orders = try? JSONDecoder().decode([Order].self, from: Parser.load("orders.json")) else {
            XCTFail("testOrderRowViewModel fails")
            return
        }
        let rowViewModel1 = OrderRowViewModel(item: orders[0])
        XCTAssertEqual(rowViewModel1.id, "1234-5678-abcd")
        
        let rowViewModel2 = OrderRowViewModel(item: orders[1])
        XCTAssertEqual(rowViewModel2.id, "1234-5678-efgh")
        
        XCTAssertNotEqual(rowViewModel1, rowViewModel2)
    }
    
    func testOrdersViewModel() {
        let expectation = XCTestExpectation(description: "testOrdersViewModel")
        
        let container = DependenciesContainerMock()
        guard let viewModel: OrdersViewModel = container.resolve(OrdersViewModel.self) else {
            XCTFail("testOrdersViewModel fails")
            return
        }
        _ = viewModel.fetch {
            XCTAssertEqual(viewModel.dataSource.count, 3)
            XCTAssertEqual(viewModel.dataSource[0].name, "BTC-DGB")
            XCTAssertEqual(viewModel.dataSource[0].orderType, .buy)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10.0)
    }
}
