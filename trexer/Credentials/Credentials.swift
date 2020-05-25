//
//  Credentials.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation
import Keys

struct Credentials {
    static let apiKey: String = {
        TrexerKeys().trexerAPIClientKey
    }()
    static let secretKey: String = {
        TrexerKeys().trexerAPIClientSecret
    }()
}
