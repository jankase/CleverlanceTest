//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case failedToCreateRequest
  case failedToDecodeResponse(Error)
}
