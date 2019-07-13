//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

extension Reactive where Base: NetworkService {
  var state: Observable<NetworkState> {
    return base.internalState.asObservable()
  }

  func imageData(userName anUserName: String, password aPassword: String) -> Observable<Data> {
    return Observable.create { anObserver in
      var theRequest: Request?
      let theDisposable = Disposables.create {
        theRequest?.cancel()
      }
      theRequest = self.base.download(userName: anUserName, password: aPassword) { aResult in
        switch aResult {
        case .success(let theData):
          anObserver.onNext(theData)
          anObserver.onCompleted()
        case .failed(let theError):
          anObserver.onError(theError)
        }
      }
      return theDisposable
    }
  }
}
