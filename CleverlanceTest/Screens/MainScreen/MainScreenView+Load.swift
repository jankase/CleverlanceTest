//
// Created by Jan Kase on 2019-07-10.
// Copyright (c) 2019 Jan Kaše. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

extension MainScreenView {
  func loadNavigationBar() {
    let theNavigationBar = UINavigationBar()
    theNavigationBar.pushItem(.init(title: "MainScreenTitle".localized), animated: false)
    theNavigationBar.delegate = self
    view.addSubview(theNavigationBar)
    theNavigationBar.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.top.equalTo(effectivePreviousConstraintItem)
    }
    previousConstraintItem = theNavigationBar.snp.bottom
    navigationBar = theNavigationBar
  }

  func loadTapHandler() {
    let theTapRecognizer = UITapGestureRecognizer()
    theTapRecognizer.rx.event.bind { [weak self] _ in self?.view.endEditing(true) }.disposed(by: disposeBag)
    view.addGestureRecognizer(theTapRecognizer)
  }

  func loadContentHolder() {
    let theContentView = UIStackView()
    view.addSubview(theContentView)
    theContentView.snp.makeConstraints {
      $0.leading.equalTo(view.snp.leadingMargin)
      $0.trailing.equalTo(view.snp.trailingMargin)
      $0.top.equalTo(effectivePreviousConstraintItem).offset(2.0 * Configuration.uiSpacing)
      $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
    }
    configureMainStack(theContentView, for: traitCollection)
    mainStack = theContentView
    let theHeader = UIStackView()
    theHeader.axis = .vertical
    theHeader.spacing = Configuration.uiSpacing
    theHeader.distribution = .fill
    theHeader.alignment = .fill
    theContentView.addArrangedSubview(theHeader)
    headerStack = theHeader
  }

  func configureMainStack(_ aStack: UIStackView?, for aTrait: UITraitCollection) {
    guard let theStack = aStack else {
      return
    }
    theStack.spacing = Configuration.uiSpacing
    let theDefaultConfiguration = {
      theStack.axis = .vertical
      theStack.distribution = .fill
    }
    switch aTrait.verticalSizeClass {
    case .regular, .unspecified:
      theDefaultConfiguration()
    case .compact:
      theStack.axis = .horizontal
      theStack.distribution = .fillEqually
      theStack.alignment = .fill
    @unknown default:
      theDefaultConfiguration()
    }
  }

  func loadUserName() {
    let theUserName = _standardTextField(labelText: "UsernameLabel".localized)
    theUserName.0.textContentType = .username
    theUserName.0.rx.text.bind(to: model.internalUserName).disposed(by: disposeBag)
    userName = theUserName.0
    userNameStack = theUserName.1
    configureTextStack(userNameStack, for: traitCollection)
  }

  func configureTextStack(_ aStack: UIStackView?, for aTrait: UITraitCollection) {
    guard let theStack = aStack else {
      return
    }
    let theDefaultConfiguration = {
      theStack.axis = .horizontal
      theStack.distribution = .fill
      theStack.alignment = .firstBaseline

    }
    switch aTrait.verticalSizeClass {
    case .regular, .unspecified:
      theDefaultConfiguration()
    case .compact:
      theStack.axis = .vertical
      theStack.distribution = .fillProportionally
      theStack.alignment = .fill
    @unknown default:
      theDefaultConfiguration()
    }
  }

  func loadPassword() {
    let thePassword = _standardTextField(labelText: "PasswordLabel".localized)
    thePassword.0.isSecureTextEntry = true
    thePassword.0.textContentType = .password
    thePassword.0.rx.text.bind(to: model.internalPassword).disposed(by: disposeBag)
    if let theUserName = userName {
      theUserName.setNextResponder(thePassword.0, disposeBag: disposeBag)
      theUserName.snp.makeConstraints {
        $0.width.equalTo(thePassword.0.snp.width)
      }
    }
    thePassword.0.rx.controlEvent(.editingDidEndOnExit)
        .filter { [weak self] in self?.model.canPerformLogin ?? false }
        .bind { [weak self] in self?._loginButtonHandler() }
        .disposed(by: disposeBag)
    password = thePassword.0
    passwordStack = thePassword.1
    configureTextStack(passwordStack, for: traitCollection)
  }

  func loadLoginButton() {
    let theLoginButton = UIButton(type: .system)
    theLoginButton.setTitle("DownloadButton".localized, for: .normal)
    model.rx.canEnableLoginButton.bind(to: theLoginButton.rx.isEnabled).disposed(by: disposeBag)
    theLoginButton.rx.controlEvent(.touchUpInside)
        .bind { [weak self] in self?._loginButtonHandler() }
        .disposed(by: disposeBag)
    let theNetworkState = UILabel()
    theNetworkState.numberOfLines = 0
    theNetworkState.lineBreakMode = .byWordWrapping
    model.rx.networkStateInfo.bind(to: theNetworkState.rx.text).disposed(by: disposeBag)
    let theContainer = UIStackView(arrangedSubviews: [theNetworkState, theLoginButton])
    configureLoginButtonStack(theContainer, for: traitCollection)
    headerStack?.addArrangedSubview(theContainer)
    loginButtonStack = theContainer
    networkStateLabel = theNetworkState
  }

  func configureLoginButtonStack(_ aStack: UIStackView?, for aTrait: UITraitCollection) {
    guard let theStack = aStack else {
      return
    }
    switch aTrait.verticalSizeClass {
    case .regular, .unspecified:
      theStack.axis = .horizontal
      theStack.alignment = .firstBaseline
      theStack.distribution = .equalCentering
    case .compact:
      theStack.axis = .vertical
      theStack.alignment = .center
      theStack.distribution = .fill
    @unknown default: ()
    }
  }

  func loadImage() {
    let theImageView = ScaledImageView()
    theImageView.contentMode = .scaleAspectFit
    mainStack?.addArrangedSubview(theImageView)
    image = theImageView
  }

  private func _loginButtonHandler() {
    guard !model.loadingRequestedAndNotCompleted else {
      return
    }
    model.loadingRequestedAndNotCompleted = true
    image?.image = nil
    view.endEditing(true)
    model.rx.loadImage()
        .observeOn(MainScheduler.asyncInstance)
        .subscribe { [weak self] aResult in
          defer {
            self?.model.loadingRequestedAndNotCompleted = false
          }
          switch aResult {
          case .next(let theData):
            self?.image?.image = theData.image
          case .error(let theError):
            self?.showError(theError)
          case .completed: ()
          }
        }
        .disposed(by: disposeBag)
  }

  private func _standardTextField(labelText aText: String) -> (UITextField, UIStackView) {
    let theDescriptionLabel = UILabel()
    theDescriptionLabel.text = aText
    let theStandardTextField = UITextField()
    theStandardTextField.autocorrectionType = .no
    theStandardTextField.autocapitalizationType = UITextAutocapitalizationType.none
    theStandardTextField.borderStyle = .roundedRect
    theStandardTextField.backgroundColor = Configuration.Colors.textFieldBackground
    let theContainer = UIStackView(arrangedSubviews: [theDescriptionLabel, theStandardTextField])
    theContainer.spacing = Configuration.uiSpacing
    theContainer.distribution = .fill
    theContainer.alignment = .firstBaseline
    theContainer.axis = .horizontal
    headerStack?.addArrangedSubview(theContainer)
    return (theStandardTextField, theContainer)
  }
}
