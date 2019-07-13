//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

extension UIViewController {
  func showError(_ anError: Error) {
    let theText = anError.localizedDescription
    let theErrorAlert = UIAlertController(title: "Error", message: theText, preferredStyle: .alert)
    theErrorAlert.addAction(.init(title: "OK", style: .default))
    present(theErrorAlert, animated: true)
  }
}
