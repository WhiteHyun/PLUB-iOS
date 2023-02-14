//
//  ParticipantCollectionViewCell.swift
//  PLUB
//
//  Created by 이건준 on 2023/02/14.
//

import UIKit

import Kingfisher
import SnapKit
import Then

struct ParticipantCollectionViewCellModel {
  let name: String
  let imageName: String
}

class ParticipantCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "ParticipantCollectionViewCell"
  
  private let participantImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.masksToBounds = true
  }
  
  private let pariticipantNameLabel = UILabel().then {
    $0.textColor = .black
    $0.font = .body1
    $0.textAlignment = .center
    $0.numberOfLines = 1
    $0.lineBreakMode = .byTruncatingTail
    $0.sizeToFit()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let imageSize = participantImageView.bounds.size
    participantImageView.layer.cornerRadius = imageSize.width / 2
  }
  
  private func configureUI() {
    contentView.backgroundColor = .background
    [participantImageView, pariticipantNameLabel].forEach { contentView.addSubview($0) }
    participantImageView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.size.equalTo(48)
    }
    
    pariticipantNameLabel.snp.makeConstraints {
      $0.top.equalTo(participantImageView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
  
  public func configureUI(with model: ParticipantCollectionViewCellModel) {
//    guard let url = URL(string: model.imageName) else { return }
//    participantImageView.kf.setImage(with: url)
    pariticipantNameLabel.text = model.name
    participantImageView.image = UIImage(systemName: "person.fill")
  }
}
