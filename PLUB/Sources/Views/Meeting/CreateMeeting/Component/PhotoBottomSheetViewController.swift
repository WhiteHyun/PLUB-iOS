//
//  PhotoBottomSheetViewController.swift
//  PLUB
//
//  Created by 김수빈 on 2023/01/17.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

protocol PhotoBottomSheetDelegate: AnyObject {
  func selectImage(image: UIImage)
}

final class PhotoBottomSheetViewController: BottomSheetViewController {
  weak var delegate: PhotoBottomSheetDelegate?
  
  private let contentStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 8
    $0.backgroundColor = .background
  }
  
  private let cameraView = PhotoBottomSheetListView(
    text: "카메라로 촬영",
    image: "camera"
  )
  
  private let albumView = PhotoBottomSheetListView(
    text: "앨범에서 사진 업로드",
    image: "selectPhotoBlack"
  )
  
  private lazy var photoPicker = UIImagePickerController().then {
    $0.delegate = self
  }
  
  override func setupLayouts() {
    super.setupLayouts()
    contentView.addSubview(contentStackView)
    
    [cameraView, albumView].forEach {
      contentStackView.addArrangedSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    contentStackView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(36)
      $0.directionalHorizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().inset(24)
    }
    
    cameraView.snp.makeConstraints {
      $0.height.equalTo(48)
    }
    
    albumView.snp.makeConstraints {
      $0.height.equalTo(48)
    }
  }
  
  override func bind() {
    super.bind()
    cameraView.button.rx.tap
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.photoPicker.sourceType = .camera
        owner.present(owner.photoPicker, animated: true)
      }
      .disposed(by: disposeBag)
    
    albumView.button.rx.tap
      .asDriver()
      .drive(with: self) { owner, _ in
        owner.photoPicker.sourceType = .photoLibrary
        owner.present(owner.photoPicker, animated: true)
      }
      .disposed(by: disposeBag)
  }
}

extension PhotoBottomSheetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let selectedImage = info[.originalImage] as? UIImage else { return }
    
    picker.dismiss(animated: true) {
      self.delegate?.selectImage(image: selectedImage)
      self.dismiss(animated: true)
    }
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) {
      self.dismiss(animated: true)
    }
  }
}
