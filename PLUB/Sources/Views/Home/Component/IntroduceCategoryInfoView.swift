//
//  IntroduceCategoryInfoView.swift
//  PLUB
//
//  Created by 이건준 on 2023/01/18.
//

import UIKit

import SnapKit
import Then

struct IntroduceCategoryInfoViewModel {
  let recommendedText: String
  let meetingImage: String
  let categortInfoListModel: CategoryInfoListModel
}

final class IntroduceCategoryInfoView: UIView {
  
  private let meetingRecommendedLabel = UILabel().then {
    $0.font = .systemFont(ofSize: 32)
    $0.textColor = .main
    $0.textAlignment = .center
    $0.sizeToFit()
  }
  
  private let categoryInfoListView = CategoryInfoListView(categoryAlignment: .horizontal, categoryListType: .noLocation)
  
  private let meetingImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.layer.cornerRadius = 10
    $0.layer.masksToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    [meetingRecommendedLabel, categoryInfoListView, meetingImageView].forEach { addSubview($0) }
    categoryInfoListView.configureUI(with: .init(placeName: "서울 서초구", peopleCount: 10, when: "매주 금요일 | 오후 5시 30분"))
    meetingRecommendedLabel.snp.makeConstraints {
      $0.left.top.right.equalToSuperview()
    }
    
    categoryInfoListView.snp.makeConstraints {
      $0.top.equalTo(meetingRecommendedLabel.snp.bottom)
      $0.left.equalToSuperview()
      $0.right.lessThanOrEqualToSuperview()
    }
    
    meetingImageView.snp.makeConstraints {
      $0.top.equalTo(categoryInfoListView.snp.bottom)
      $0.left.right.bottom.equalToSuperview()
    }
  }
  
  public func configureUI(with model: IntroduceCategoryInfoViewModel) {
    guard let url = URL(string: model.meetingImage) else { return }
    meetingRecommendedLabel.text = model.recommendedText
    categoryInfoListView.configureUI(with: model.categortInfoListModel)
    meetingImageView.kf.setImage(with: url)
  }
}
