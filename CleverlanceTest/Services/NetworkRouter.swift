//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Alamofire
import Foundation

enum NetworkRouter: URLRequestConvertible {
  case image(userName: String, password: String)

  func asURLRequest() throws -> URLRequest {
    switch self {
    case let .image(theUserName, thePassword):
      var theResult = try URLRequest(url: Configuration.url, method: .post)
      theResult.setValue(thePassword.passwordHash, forHTTPHeaderField: "Authorization")
      theResult.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
      theResult.httpBody = "username=\(theUserName)".data(using: .utf8)
      return theResult
    }
  }
}
