//
//  CurrencyTests.swift
//  trexerTests
//
//  Created by Malik Alayli on 28/05/2020.
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer

final class CurrencyTests: XCTestCase {
    func testCurrencyDecoding() {
        do {
            let currency = try JSONDecoder().decode([Currency].self, from: Parser.load("currency.json"))
            XCTAssertEqual(currency.first?.logoUrl, "https://bittrexblobstorage.blob.core.windows.net/public/5685a7be-1edf-4ba0-a313-b5309bb204f8.png")
        } catch {
            print(error)
            XCTFail("testCurrencyDecoding fails")
        }
    }
}
