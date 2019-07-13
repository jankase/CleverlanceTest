//
// Created by Jan Kase on 2019-07-10.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class MainScreenViewModel: ReactiveCompatible {
  var networkService: NetworkService = .shared
  var internalUserName: BehaviorRelay<String?> = .init(value: nil)
  var internalPassword: BehaviorRelay<String?> = .init(value: nil)

  var userName: String? {
    return internalUserName.value
  }
  var password: String? {
    return internalPassword.value
  }
  var networkStateText: String? {
    return networkService.state.userInfo
  }
}
