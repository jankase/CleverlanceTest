//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError, CustomStringConvertible {
  case failedToCreateRequest
  case failedToDecodeResponse(Error)
  case wrongCredentials

  var description: String {
    switch self {
    case .failedToCreateRequest:
      return "FailedCreateRequestError".localized
    case .failedToDecodeResponse:
      return "FailedToDecodeResponseError".localized
    case .wrongCredentials:
      return "WrongCredentialsError".localized
    }
  }
  var errorDescription: String? {
    return description
  }

  static func networkError(statusCode aStatusCode: Int?, originalError anError: Error) -> Error {
    guard let theStatusCode = aStatusCode else {
      return anError
    }
    switch theStatusCode {
    case 401:
      return NetworkError.wrongCredentials
    default:
      return anError
    }
  }
}
