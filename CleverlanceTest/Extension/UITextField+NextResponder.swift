//
// Created by Jan Kase on 2019-07-11.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UITextField {
  func resignWhenFinished(disposeBag aDisposeBag: DisposeBag) {
    setNextResponder(nil, disposeBag: aDisposeBag)
  }

  func setNextResponder(_ aNextResponder: UIResponder?, disposeBag aDisposeBag: DisposeBag) {
    returnKeyType = aNextResponder == nil ? .done : .next
    rx.controlEvent(.editingDidEndOnExit)
        .bind { [weak self, weak aNextResponder] in
          guard let theNextResponder = aNextResponder else {
            self?.resignFirstResponder()
            return
          }
          theNextResponder.becomeFirstResponder()
        }
        .disposed(by: aDisposeBag)
  }
}
