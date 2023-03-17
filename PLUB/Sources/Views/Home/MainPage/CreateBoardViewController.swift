//
//  CreateBoardViewController.swift
//  PLUB
//
//  Created by 이건준 on 2023/03/17.
//

import UIKit

import SnapKit
import Then

final class CreateBoardViewController: BaseViewController {
  
  private let boardTypeLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .subtitle
    $0.text = "게시판 타입"
  }
  
  private let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
  }
  
  private let photoButton: UIButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.list(label: "사진 Only")
    $0.isSelected = true
  }
  
  private let textButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.list(label: "글 Only")
  }
  
  private let photoAndTextButton: UIButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.list(label: "사진+글")
  }
  
  private let titleInputTextView = InputTextView(title: "제목", placeHolder: "제목을 입력해주세요")
  
  private let boardTypeStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
  }

  private let photoAddLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .subtitle
    $0.text = "사진 추가"
  }
  
  private let addPhotoImageView = UIImageView().then {
    $0.backgroundColor = .deepGray
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
  }
  
  override func setupStyles() {
    super.setupStyles()

    self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(didTappedBackButton))
  }
  
  override func setupLayouts() {
    super.setupLayouts()
    [photoButton, textButton, photoAndTextButton].forEach { buttonStackView.addArrangedSubview($0) }
    
    [photoAddLabel, addPhotoImageView].forEach { boardTypeStackView.addArrangedSubview($0) }
    [boardTypeLabel, buttonStackView, titleInputTextView, boardTypeStackView].forEach { view.addSubview($0) }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    boardTypeLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
      $0.leading.equalToSuperview().inset(16)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(boardTypeLabel.snp.bottom).offset(7.5)
      $0.leading.equalTo(boardTypeLabel)
      $0.trailing.lessThanOrEqualToSuperview()
    }
    
    titleInputTextView.snp.makeConstraints {
      $0.top.equalTo(buttonStackView.snp.bottom).offset(32.5)
      $0.directionalHorizontalEdges.equalToSuperview().inset(16)
    }
    
    addPhotoImageView.snp.makeConstraints {
      $0.height.equalTo(245)
    }
    
    boardTypeStackView.snp.makeConstraints {
      $0.top.equalTo(titleInputTextView.snp.bottom).offset(24)
      $0.directionalHorizontalEdges.equalToSuperview().inset(16)
      $0.bottom.lessThanOrEqualToSuperview()
    }
  }
  
  @objc private func didTappedBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
}
