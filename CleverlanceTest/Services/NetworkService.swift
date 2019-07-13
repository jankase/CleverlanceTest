//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import Alamofire
import Foundation
import RxRelay
import RxSwift

class NetworkService: ReactiveCompatible {
  static var shared: NetworkService = .init()

  var internalState: BehaviorRelay<NetworkState> = .init(value: .nothing)
  var sessionConfiguration: URLSessionConfiguration = .default
  lazy var session: SessionManager = {
    return SessionManager(configuration: self.sessionConfiguration)
  }()

  var state: NetworkState {
    get {
      return internalState.value
    }
    set(aNewState) {
      internalState.accept(aNewState)
    }
  }

  @discardableResult
  func download(userName anUserName: String,
                password aPassword: String,
                completionHandler aCompletionHandler: @escaping (ImageResult) -> Void) -> Request {
    state = .loadingImage
    let theRequest = session.request(NetworkRouter.image(userName: anUserName, password: aPassword))
    NSLog("\(theRequest.debugDescription)")
    return theRequest.validate(statusCode: 200..<300).responseData { [weak self] aResponse in
      self?.state = .nothing
      switch aResponse.result {
      case .success(let theData):
        do {
          aCompletionHandler(.success(try JSONDecoder().decode(ImageDataResponse.self, from: theData)))
        } catch let theError {
          aCompletionHandler(.failed(NetworkError.failedToDecodeResponse(theError)))
        }
      case .failure(let theError):
        aCompletionHandler(.failed(theError))
      }
    }
  }
}
