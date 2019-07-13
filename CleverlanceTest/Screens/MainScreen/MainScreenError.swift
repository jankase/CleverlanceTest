//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

enum MainScreenError: LocalizedError, CustomStringConvertible {
  case missingLoginInformation

  var description: String {
    switch self {
    case .missingLoginInformation:
      return "MissingCredentials".localized
    }
  }
  var errorDescription: String? {
    return description
  }
}
