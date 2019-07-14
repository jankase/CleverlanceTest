//
// Created by Jan Kase on 2019-07-11.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

struct Configuration {
  static let uiSpacing: CGFloat = 10
  static let standardTextFieldHeight: CGFloat = 40
  static let standardButtonHeight = 40
  static let url: String = "https://mobility.cleverlance.com/download/bootcamp/image.php"

  struct Colors {
    static let defaultTint = #colorLiteral(red: 40.0 / 255.0, green: 17.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    static let background = #colorLiteral(red: 141.0 / 255.0, green: 170.0 / 255.0, blue: 143.0 / 255.0, alpha: 1.0)
    static let textFieldBackground = #colorLiteral(red: 120.0 / 255.0, green: 132.0 / 255.0, blue: 117.0 / 255.0, alpha: 1.0)
    static let disabled = #colorLiteral(red: 94.0 / 255.0, green: 93.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
  }
}
