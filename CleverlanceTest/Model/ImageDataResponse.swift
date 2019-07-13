//
// Created by Jan Kase on 2019-07-13.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

struct ImageDataResponse: Decodable {
  var image: UIImage?

  init(from aDecoder: Decoder) throws {
    let theContainer = try aDecoder.container(keyedBy: _Keys.self)
    let theImageString = try theContainer.decode(String.self, forKey: .image)
    if let theData = Data(base64Encoded: theImageString), let theImage = UIImage(data: theData) {
      image = theImage
    }
  }

  private enum _Keys: String, CodingKey {
    case image
  }
}
