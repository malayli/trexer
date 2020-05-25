//
//  CryptoTests.swift
//  TrexerTests
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import XCTest
@testable import trexer

final class CryptoTests: XCTestCase {
    func testApiSign() {
        let apiSign = Crypto.hmac(mixString: "https://bittrex.com/api/v1.1/account/getbalances?apikey=blabla&nonce=123456789.0", secretKey: "secretKey")
        XCTAssertEqual(apiSign, "64561b7502bdcbe2fda53d50f76926e20d747ae7c6547cfffc501b09800e87c5ce2f2c26a64118e2e29e121c21433487c4c3132b241db59871081f8b2404c096")
    }
}
