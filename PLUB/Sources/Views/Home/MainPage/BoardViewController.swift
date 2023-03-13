//
//  BoardViewController.swift
//  PLUB
//
//  Created by 이건준 on 2023/03/02.
//

import UIKit

import SnapKit
import Then

enum BoardHeaderViewType {
  case clipboard // 클립보드 목록이 하나 이상 존재할 때
  case noClipboard // 클립보드 목록이 하나도 존재하지않을 때
}

protocol BoardViewControllerDelegate: AnyObject {
  func calculateHeight(_ height: CGFloat)
}

final class BoardViewController: BaseViewController {
  
  weak var delegate: BoardViewControllerDelegate?
  
  private let viewModel: BoardViewModelType
  
  /// 스크롤 영역에 따른 헤더 뷰 높이변경을 위한 프로퍼티
  private let min: CGFloat = Device.navigationBarHeight
  private let max: CGFloat = 292
  
  /// 아래 타입의 ClipboardType에 따라 다른 UI를 구성
  private var headerType: BoardHeaderViewType = .clipboard {
    didSet {
      collectionView.reloadSections([0])
    }
  }
  
  private var clipboardModel: [MainPageClipboardViewModel] = [] {
    didSet {
      collectionView.reloadSections([0])
    }
  }
  
  private lazy var collectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewCompositionalLayout { [weak self] sec, env -> NSCollectionLayoutSection? in
      guard let self = self else { return nil }
      return self.createCollectionViewSection()
    }
  ).then {
    $0.backgroundColor = .background
    $0.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: BoardCollectionViewCell.identifier)
    $0.register(BoardClipboardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BoardClipboardHeaderView.identifier)
    $0.delegate = self
    $0.dataSource = self
    $0.bounces = false
    $0.contentInset = .init(top: 16, left: .zero, bottom: .zero, right: .zero)
  }
  
  init(viewModel: BoardViewModelType = BoardViewModel()) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setupLayouts() {
    super.setupLayouts()
    view.addSubview(collectionView)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    collectionView.snp.makeConstraints {
      $0.directionalEdges.equalToSuperview()
    }
  }
  
  override func bind() {
    super.bind()
    
    viewModel.selectPlubbingID.onNext(1)
    
    viewModel.fetchedMainpageClipboardViewModel
      .drive(rx.clipboardModel)
      .disposed(by: disposeBag)
    
    viewModel.clipboardListIsEmpty
      .drive(with: self) { owner, isEmpty in
        owner.headerType = isEmpty ? .noClipboard : .clipboard
      }
      .disposed(by: disposeBag)
    
    viewModel.fetchedBoardModel
      .drive(onNext: { model in
        print("모델 \(model)")
      })
      .disposed(by: disposeBag)
  }
  
  private func createCollectionViewSection() -> NSCollectionLayoutSection? {
    let item = NSCollectionLayoutItem(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .fractionalHeight(1)
      )
    )
    
    item.contentInsets = .init(top: .zero, leading: .zero, bottom: 8, trailing: .zero)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1),
        heightDimension: .absolute(107)),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .none
    
    switch headerType {
    case .clipboard:
      let header = NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(260)
        ),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
      section.boundarySupplementaryItems = [header]
      section.contentInsets = .init(top: 16, leading: 16, bottom: .zero, trailing: 16)
    case .noClipboard:
      section.boundarySupplementaryItems = []
      section.contentInsets = .init(top: .zero, leading: 16, bottom: 16, trailing: 16)
    }
    return section
  }
}

extension BoardViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scroll = scrollView.contentOffset.y
    
    let heightTemp = max - scroll
    
    if heightTemp > max {
      delegate?.calculateHeight(max)
    } else if heightTemp < min {
      delegate?.calculateHeight(min)
    } else {
      delegate?.calculateHeight(heightTemp)
    }
  }
}

extension BoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.identifier, for: indexPath) as? BoardCollectionViewCell ?? BoardCollectionViewCell()
    cell.configure(with: BoardModel(feedID: 0, viewType: .normal, author: "개나리", authorProfileImageLink: nil, date: .now, likeCount: 3, commentCount: 5, title: "게시판 제목", imageLink: nil, content: nil))
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BoardClipboardHeaderView.identifier, for: indexPath) as? BoardClipboardHeaderView ?? BoardClipboardHeaderView()
    header.configureUI(with: clipboardModel)
    header.delegate = self
    return header
  }
}

extension BoardViewController: BoardClipboardHeaderViewDelegate {
  func didTappedClipboardButton() {
    let vc = ClipboardViewController(viewModel: ClipboardViewModel(plubbingID: 0))
    vc.navigationItem.largeTitleDisplayMode = .never
    self.navigationController?.pushViewController(vc, animated: true)
  }
}

