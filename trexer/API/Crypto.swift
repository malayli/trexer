//
//  Crypto.swift
//  Trexer
//
//  Copyright © 2020 Digital Fox. All rights reserved.
//

import Foundation
import CommonCrypto

enum Crypto {
    static func hmac(mixString: String, secretKey: String) -> String? {
        guard let signatureData : Data = mixString.data(using: .utf8) else {
            return nil
        }
        let keyDataUint8: Array<UInt8> = Array(secretKey.utf8)
        let digest = UnsafeMutablePointer<UInt8>.allocate(capacity:Int(CC_SHA512_DIGEST_LENGTH))
        var hmacContext = CCHmacContext()
        CCHmacInit(&hmacContext, CCHmacAlgorithm(kCCHmacAlgSHA512), keyDataUint8, keyDataUint8.count)
        CCHmacUpdate(&hmacContext, [UInt8](signatureData), [UInt8](signatureData).count)
        CCHmacFinal(&hmacContext, digest)
        let macData = Data(bytes: digest, count: Int(CC_SHA512_DIGEST_LENGTH))
        return  macData.hexEncodedString()
    }
}
