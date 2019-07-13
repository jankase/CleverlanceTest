//
// Created by Jan Kase on 2019-07-11.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import UIKit

extension MainScreenView: UINavigationBarDelegate {
  public func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}
