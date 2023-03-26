import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class MeetingViewController: BaseViewController {
  
  private let viewModel = MeetingViewModel()
  
  private var meetingList: [MeetingCellModel] = [] {
    didSet {
      self.collectionView.reloadData()
    }
  }
  
  private var previousIndex: Int?
  
  private let meetingTypeControl = MeetingTypeControl(items: ["내모임", "호스트"]).then {
    $0.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.button], for: .normal)
    $0.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: UIFont.button], for: .selected)
    $0.selectedSegmentIndex = 0

    $0.backgroundColor = .background
  }
  
  private let pageControl = PageControl().then {
    $0.numberOfPages = 1
  }
  
  private let collectionViewLayout = UICollectionViewFlowLayout().then {
    $0.minimumInteritemSpacing = 0
    $0.minimumLineSpacing = Constants.itemSpacing
    $0.itemSize = Constants.itemSize
    $0.scrollDirection = .horizontal
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: collectionViewLayout
  ).then {
    $0.backgroundColor = .background
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
    $0.dataSource = self
    $0.isScrollEnabled = true
    $0.clipsToBounds = true
    $0.register(MeetingCollectionViewCell.self, forCellWithReuseIdentifier: "MeetingCollectionViewCell")
    $0.register(MeetingCollectionMoreCell.self, forCellWithReuseIdentifier: "MeetingCollectionMoreCell")
    $0.isPagingEnabled = false
    $0.contentInsetAdjustmentBehavior = .never
    $0.contentInset = Constants.collectionViewContentInset
    $0.decelerationRate = .fast
    $0.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func setupLayouts() {
    super.setupLayouts()
    [meetingTypeControl, pageControl, collectionView].forEach {
      view.addSubview($0)
    }
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    meetingTypeControl.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
      $0.width.equalTo(144)
      $0.height.equalTo(32)
      $0.centerX.equalToSuperview()
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(meetingTypeControl.snp.bottom).offset(36)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(433)
    }
    
    pageControl.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(24)
      $0.centerX.equalToSuperview()
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    setupNavigationBar()
  }
  
  override func bind() {
    super.bind()
    
    viewModel.meetingList
      .drive(with: self) { owner, data in
        owner.meetingList = data
        owner.pageControl.numberOfPages = data.count
        guard !data.isEmpty else { return }
        owner.collectionView.scrollToItem(
          at: IndexPath(row: 0, section: 0),
          at: .centeredHorizontally,
          animated: true
        )
      }
      .disposed(by: disposeBag)
    
    meetingTypeControl
      .rx.value
      .asDriver()
      .drive(with: self) { owner, index in
        let isHost = index == 0 ? false : true
        owner.viewModel.fetchMyMeeting(isHost: isHost)
      }
      .disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    let logoImageView = UIImageView().then {
      $0.image = UIImage(named: "plubIcon522x147")
      $0.contentMode = .scaleAspectFill
    }
    
    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoImageView)
  }
}
extension MeetingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return meetingList.count
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.row < meetingList.count - 1 {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MeetingCollectionViewCell.identifier,
        for: indexPath
      ) as? MeetingCollectionViewCell else { return UICollectionViewCell() }
      cell.setupData(with: meetingList[indexPath.row])
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MeetingCollectionMoreCell.identifier,
        for: indexPath
      ) as? MeetingCollectionMoreCell else { return UICollectionViewCell() }
      cell.setupData(isDimmed: meetingList[indexPath.row].isDimmed)
      return cell
    }
  }
    
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row < meetingList.count - 1 {
      guard let plubbing = meetingList[indexPath.row].plubbing else { return }
      // 플러빙 메인
      let vc = MainPageViewController(plubbingID: plubbing.plubbingID)
      vc.navigationItem.largeTitleDisplayMode = .never
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
    } else {
      // 모임 생성
      let vc = CreateMeetingViewController()
      vc.hidesBottomBarWhenPushed = true
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
    let cellWidth = Constants.itemSize.width + Constants.itemSpacing
    let index = round(scrolledOffsetX / cellWidth)
    
    targetContentOffset.pointee = CGPoint(
      x: index * cellWidth - scrollView.contentInset.left,
      y: scrollView.contentInset.top
    )
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard !meetingList.isEmpty else { return }
    
    let scrolledOffset = scrollView.contentOffset.x + scrollView.contentInset.left
    let cellWidth = Constants.itemSize.width + Constants.itemSpacing
    let index = Int(round(scrolledOffset / cellWidth))
    
    pageControl.currentPage = index
    
    guard index < meetingList.count else { return }
    self.meetingList[index].isDimmed = false
    
    defer {
      self.previousIndex = index
      self.collectionView.reloadData()
    }
    
    guard let previousIndex = self.previousIndex,
      previousIndex != index
    else { return }
    self.meetingList[previousIndex].isDimmed = true
  }
}

extension MeetingViewController {
  private enum Constants {
    static let itemSize = CGSize(width: 300, height: 433)
    static let itemSpacing = CGFloat(16)
    
    static var insetX: CGFloat {
      (Device.width - self.itemSize.width) / 2.0
    }
    static var collectionViewContentInset: UIEdgeInsets {
      UIEdgeInsets(top: 0, left: self.insetX, bottom: 0, right: self.insetX)
    }
  }
}
