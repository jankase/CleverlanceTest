//
// Created by Jan Kase on 2019-07-11.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: MainScreenViewModel {
  var canEnableLoginButton: Observable<Bool> {
    return Observable.combineLatest(base.internalUserName,
                                    base.internalPassword,
                                    base.networkService.rx.state) { anUserName, aPassword, aNetworkState in
      switch aNetworkState {
      case .nothing:
        return !((anUserName?.isEmpty ?? true) || (aPassword?.isEmpty ?? true))
      default:
        return false
      }
    }
  }
  var networkStateInfo: Observable<String?> {
    return base.networkService.rx.state.map { $0.userInfo }.observeOn(MainScheduler.asyncInstance)
  }

  func loadImage() -> Observable<ImageDataResponse> {
    guard let theUserName = base.userName,
          let thePassword = base.password,
          !theUserName.isEmpty && !thePassword.isEmpty else {
      return Observable.error(MainScreenError.missingLoginInformation)
    }
    return base.networkService.rx
        .imageData(userName: theUserName, password: thePassword)
        .subscribeOn(SerialDispatchQueueScheduler(qos: .default))
  }
}
