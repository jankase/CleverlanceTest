//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

class ScaledImageView: UIImageView {
  override var intrinsicContentSize: CGSize {
    guard let theImage = image else {
      return .init(width: -1, height: -1)
    }
    guard frame.width < theImage.size.width else {
      return theImage.size
    }
    let theRatio = frame.width / theImage.size.width
    let theNewHeight = theImage.size.height * theRatio
    return .init(width: frame.width, height: theNewHeight)
  }
}
