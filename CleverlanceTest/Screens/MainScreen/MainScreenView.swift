//
// Created by Jan Kase on 2019-07-10.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import RxSwift
import SnapKit
import UIKit

class MainScreenView: UIViewController {
  var model: MainScreenViewModel = .init()

  weak var mainStack: UIStackView?
  weak var headerStack: UIStackView?
  weak var userNameStack: UIStackView?
  weak var userName: UITextField?
  weak var passwordStack: UIStackView?
  weak var password: UITextField?
  weak var loginButtonStack: UIStackView?
  weak var loginButton: UIButton?
  weak var networkStateLabel: UILabel?
  weak var imageStack: UIStackView?
  weak var image: UIImageView?
  weak var navigationBar: UINavigationBar?
  var previousConstraintItem: ConstraintItem?
  var disposeBag: DisposeBag = .init()
  var effectivePreviousConstraintItem: ConstraintItem {
    return previousConstraintItem ?? view.safeAreaLayoutGuide.snp.top
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white
    loadNavigationBar()
    loadContentHolder()
    loadUserName()
    loadPassword()
    loadLoginButton()
    loadImage()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    userName?.becomeFirstResponder()
  }
}
