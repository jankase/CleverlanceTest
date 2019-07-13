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
    theNavigationBar.pushItem(.init(title: "Image loader"), animated: false)
    theNavigationBar.delegate = self
    theNavigationBar.backgroundColor = view.tintColor
    view.addSubview(theNavigationBar)
    theNavigationBar.snp.makeConstraints {
      $0.leading.equalToSuperview()
      $0.trailing.equalToSuperview()
      $0.top.equalTo(effectivePreviousConstraintItem)
    }
    previousConstraintItem = theNavigationBar.snp.bottom
    navigationBar = theNavigationBar
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
    theContentView.axis = .vertical
    theContentView.spacing = Configuration.uiSpacing
    theContentView.isLayoutMarginsRelativeArrangement = true
    content = theContentView
  }

  func loadUserName() {
    let theUserNameText = _standardTextField(labelText: "Username")
    theUserNameText.textContentType = .username
    theUserNameText.rx.text.bind(to: model.internalUserName).disposed(by: disposeBag)
    userName = theUserNameText
  }

  func loadPassword() {
    let thePassword = _standardTextField(labelText: "Password")
    thePassword.isSecureTextEntry = true
    thePassword.textContentType = .password
    thePassword.rx.text.bind(to: model.internalPassword).disposed(by: disposeBag)
    if let theUserName = userName {
      theUserName.setNextResponder(thePassword, disposeBag: disposeBag)
      theUserName.snp.makeConstraints {
        $0.width.equalTo(thePassword.snp.width)
      }
    }
    password = thePassword
  }

  func loadLoginButton() {
    let theLoginButton = UIButton(type: .system)
    theLoginButton.setTitle("Login & Download", for: .normal)
    model.rx.canEnableLoginButton.bind(to: theLoginButton.rx.isEnabled).disposed(by: disposeBag)
    theLoginButton.rx.controlEvent(.touchUpInside)
        .bind { [weak self] in self?._loginButtonHandler() }
        .disposed(by: disposeBag)
    let theNetworkState = UILabel()
    model.rx.networkStateInfo.bind(to: theNetworkState.rx.text).disposed(by: disposeBag)
    let theContainer = UIStackView(arrangedSubviews: [theNetworkState, theLoginButton])
    theContainer.axis = .horizontal
    theContainer.alignment = .trailing
    theContainer.distribution = .equalCentering
    content?.addArrangedSubview(theContainer)
  }

  func loadImage() {
    let theImageView = ScaledImageView()
    theImageView.contentMode = .scaleAspectFit
    content?.addArrangedSubview(theImageView)
    image = theImageView
  }

  private func _loginButtonHandler() {
    model.rx.loadImage()
        .observeOn(MainScheduler.asyncInstance)
        .subscribe { [weak self] aResult in
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

  private func _standardTextField(labelText aText: String) -> UITextField {
    let theDescriptionLabel = UILabel()
    theDescriptionLabel.text = aText
    let theStandardTextField = UITextField()
    theStandardTextField.autocorrectionType = .no
    theStandardTextField.autocapitalizationType = UITextAutocapitalizationType.none
    theStandardTextField.borderStyle = .roundedRect
    let theContainer = UIStackView(arrangedSubviews: [theDescriptionLabel, theStandardTextField])
    theContainer.spacing = Configuration.uiSpacing
    theContainer.distribution = .fill
    theContainer.alignment = .firstBaseline
    theContainer.axis = .horizontal
    content?.addArrangedSubview(theContainer)
    return theStandardTextField
  }
}
