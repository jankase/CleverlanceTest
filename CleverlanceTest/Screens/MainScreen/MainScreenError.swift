//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

enum MainScreenError: Error, CustomStringConvertible {
  case missingLoginInformation

  var description: String {
    switch self {
    case .missingLoginInformation:
      return "Username or password not available"
    }
  }
  var localizedDescription: String {
    return description
  }
}
