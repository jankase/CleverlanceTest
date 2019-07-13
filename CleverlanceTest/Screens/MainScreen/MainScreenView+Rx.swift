//
// Created by Jan Kase on 2019-07-12.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: MainScreenView {
  var loginButtonBackgroundColor: Observable<UIColor?> {
    return base.model.rx.canEnableLoginButton.map {
      return $0 ? self.base.view.tintColor : .lightGray
    }
  }
}
