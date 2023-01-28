//
//  IntroduceCategoryViewController.swift
//  PLUB
//
//  Created by 이건준 on 2023/01/02.
//

import UIKit

import SnapKit
import Then

// TODO: -이건준 plubbingId를 통해 받아온 DetailRecruitmentModel을 이용
final class DetailRecruitmentViewController: BaseViewController {
  
  private let viewModel: DetailRecruitmentViewModelType
  private let plubbingId: Int
  private var model: SelectedCategoryCollectionViewCellModel?
  let mod = [
    "이건준",
    "이건준ㅇㄹ",
    "이건준ㅁㄹ",
    "이건준ㅁㅁㅁㅁ",
    "이건",
    "이건",
    "이건",
    "이",
    "이afasfasf",
  ]
  
  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = true
    $0.showsHorizontalScrollIndicator = false
    $0.alwaysBounceVertical = true
  }
  
  private lazy var introduceTypeStackView = UIStackView(arrangedSubviews: [
    introduceCategoryTitleView, introduceCategoryInfoView, meetingIntroduceView, introduceTagCollectionView, participantListView, bottomStackView
  ]).then {
    $0.axis = .vertical
    $0.alignment = .center
    $0.distribution = .fill
    $0.isLayoutMarginsRelativeArrangement = true
    $0.spacing = 24
    $0.layoutMargins = UIEdgeInsets(top: .zero, left: 16.5, bottom: .zero, right: 16.5)
  }
  
  private lazy var bottomStackView = UIStackView(arrangedSubviews: [surroundMeetingButton, applyButton]).then {
    $0.axis = .horizontal
    $0.alignment = .center
    $0.distribution = .fillEqually
    $0.spacing = 8
  }
  
  private let surroundMeetingButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.plubButton(label: "모임 둘러보기")
    $0.isEnabled = false
  }
  
  private let applyButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.plubButton(label: "같이 할래요!")
  }
  
  private let introduceCategoryTitleView = IntroduceCategoryTitleView()
  
  private let introduceCategoryInfoView = IntroduceCategoryInfoView()
  
  private let meetingIntroduceView = MeetingIntroduceView()
  
  private lazy var introduceTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then({
    $0.minimumLineSpacing = 8
    $0.minimumInteritemSpacing = 8
  })).then {
    $0.backgroundColor = .background
    $0.register(IntroduceTagCollectionViewCell.self, forCellWithReuseIdentifier: IntroduceTagCollectionViewCell.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.isScrollEnabled = false
    $0.sizeToFit()
  }
  
  private let participantListView = ParticipantListView().then {
    $0.backgroundColor = .clear
  }
  
  init(viewModel: DetailRecruitmentViewModelType = DetailRecruitmentViewModel(), plubbingId: Int) {
    self.viewModel = viewModel
    self.plubbingId = plubbingId
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(scrollView)
    scrollView.addSubview(introduceTypeStackView)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    
    scrollView.snp.makeConstraints {
      $0.edges.width.equalToSuperview() // 타이틀에 대한 너비까지 잡아줌으로써 Vertical Enabled한 UI를 구성
    }
    
    introduceTypeStackView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
    }
    
    introduceTagCollectionView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16)
      $0.height.greaterThanOrEqualTo(48)
    }
    
    participantListView.snp.makeConstraints {
      $0.left.equalToSuperview().offset(17.5)
      $0.right.lessThanOrEqualToSuperview().offset(-14.14)
      $0.height.equalTo(64)
    }
    
    bottomStackView.snp.makeConstraints {
      $0.right.equalToSuperview().offset(-16.5)
      $0.height.equalTo(46)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    view.backgroundColor = .background
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "back"),
      style: .plain,
      target: self,
      action: #selector(didTappedBackButton)
    )
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "checkBookmark"),
      style: .plain,
      target: self,
      action: #selector(didTappedComponentButton)
    )
  }
  
  override func bind() {
    super.bind()
    viewModel.selectPlubbingID.onNext(plubbingId)
//    viewModel.fetchDetailRecruitment
//      .drive(rx.)
  }
  
  @objc private func didTappedBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func didTappedComponentButton() {
    
  }
}

extension DetailRecruitmentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == introduceTagCollectionView {
      return mod.count
    }
    return mod.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == introduceTagCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroduceTagCollectionViewCell.identifier, for: indexPath) as? IntroduceTagCollectionViewCell ?? IntroduceTagCollectionViewCell()
      cell.configureUI(with: mod[indexPath.row])
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == introduceTagCollectionView {
      let label = UILabel().then {
        $0.font = .caption
        $0.text = mod[indexPath.row]
        $0.sizeToFit()
      }
      let size = label.frame.size
      return CGSize(width: size.width + 16, height: size.height + 4)
    }
    return .zero
  }
}