//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import CommonCrypto
import Foundation

extension String {
  var passwordHash: String {
    let theResult = data(using: .utf8)!.sha1.hexString
    return theResult
  }
}

extension Data {
  var hexString: String {
    return map { String(format: "%02hhx", $0) }.joined()
  }
  var sha1: Data {
    var theDigest: [UInt8] = .init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    withUnsafeBytes { _ = CC_SHA1($0, CC_LONG(self.count), &theDigest) }
    return Data(theDigest)
  }
}
