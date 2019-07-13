//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Foundation

enum NetworkState {
  case nothing
  case loadingImage

  var userInfo: String? {
    switch self {
    case .nothing:
      return nil
    case .loadingImage:
      return "NetworkStateLoading".localized
    }
  }
}
