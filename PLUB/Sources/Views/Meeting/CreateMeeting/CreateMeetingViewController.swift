//
//  CreateMeetingViewController.swift
//  PLUB
//
//  Created by 김수빈 on 2023/01/11.
//

import UIKit

import RxSwift

enum CreateMeetingType {
  case category // 카테고리
  case name // 모임 이름
  case introduction // 모임 소개
  case age // 성별, 나이
  case date // 요일
  case peopleCount // 인원
  case question // 질문 여부
}

final class CreateMeetingViewController: BaseViewController {
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var currentPage = 0 {
    didSet {
      view.endEditing(true)
      pageControl.currentPage = currentPage
    }
  }
  
  private var lastPageIndex = 0 {
    didSet {
      view.endEditing(true)
      scrollView.contentSize.width = Device.width * CGFloat(lastPageIndex)
      if oldValue < lastPageIndex {
        pushChildView(index: lastPageIndex)
      }
    }
  }
  
  private lazy var pageControl = PageControl().then {
    $0.numberOfPages = viewControllers.count
    $0.currentPage = 0
  }
  
  private lazy var scrollView = UIScrollView().then {
    $0.bounces = false
    $0.contentInsetAdjustmentBehavior = .never
    $0.isPagingEnabled = true
    $0.contentSize.width = Device.width
    $0.showsHorizontalScrollIndicator = false
    $0.delegate = self
  }
  
  private let contentStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 0
  }
  
  private var nextButton = UIButton(configuration: .plain()).then {
    $0.configurationUpdateHandler = $0.configuration?.plubButton(label: "다음")
  }
  
  private let meetingNameViewController = MeetingNameViewController(
    viewModel: MeetingNameViewModel(),
    childIndex: 0
  )
  private let meetingIntroduceViewController = MeetingIntroduceViewController(
    viewModel: MeetingIntroduceViewModel(),
    childIndex: 1
  )
  private let selectQuestionViewController = SelectQuestionViewController()
  
  private var viewControllers: [CreateMeetingType] = [.name, .introduction, .question]
  
  //TODO: 수빈 - viewModel로 빼기
  private var isNextButtonEnable = [Bool]()
  
  // MARK: - Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerKeyboardNotification()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardNotification()
  }
  
  // MARK: - Configuration
  
  override func setupLayouts() {
    super.setupLayouts()

    [pageControl, scrollView, nextButton].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(contentStackView)
  }
  
  override func setupConstraints() {
    super.setupConstraints()
    pageControl.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
      $0.leading.equalToSuperview().inset(16)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(24)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    contentStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(26)
      $0.height.width.equalTo(46)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
  }
  
  override func setupStyles() {
    super.setupStyles()
    setupNavigationBar()
    pushChildView(index: lastPageIndex)
  }
  
  override func bind() {
    super.bind()
    nextButton.rx.tap
      .withUnretained(self)
      .subscribe(onNext: { owner, _ in
        if owner.currentPage < owner.lastPageIndex {
          owner.scrollToPage(index: owner.currentPage + 1)
          owner.currentPage += 1
        } else if owner.lastPageIndex + 1 < owner.viewControllers.count {
          owner.lastPageIndex += 1
          owner.currentPage = owner.lastPageIndex
        }
      })
      .disposed(by: disposeBag)
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.tintColor = .black
    navigationController?.navigationBar.backgroundColor = .background
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "backButton"),
      style: .plain,
      target: self,
      action: #selector(didTappedBackButton)
    )
  }
  
  @objc
  private func didTappedBackButton() {
    if currentPage == 0 {
      navigationController?.popViewController(animated: true)
    } else {
      scrollToPage(index: currentPage - 1)
      currentPage -= 1
    }
  }
  
  private func pushChildView(index: Int) {
    isNextButtonEnable.append(false)
    nextButton.isEnabled = false
    
    let containerView = UIView()
    contentStackView.addArrangedSubview(containerView)
    
    addChild(selectChildViewController(index: index))
    containerView.addSubview(selectChildViewController(index: index).view)
  
    containerView.snp.makeConstraints {
      $0.width.equalTo(Device.width)
    }
    
    selectChildViewController(index: index).view.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    selectChildViewController(index: index).didMove(toParent: self)
    
    scrollToPage(index: index)
  }
  
  private func scrollToPage(index: Int) {
    let offset: CGPoint = CGPoint(x: Device.width * CGFloat(index), y: 0)
    scrollView.setContentOffset(offset, animated: true)
  }
  
  private func selectChildViewController(index: Int) -> UIViewController {
    switch viewControllers[index] {
    case .category:
      return selectQuestionViewController
    case .name:
      meetingNameViewController.delegate = self
      return meetingNameViewController
    case .introduction:
      meetingIntroduceViewController.delegate = self
      return meetingIntroduceViewController
    case .age:
      return selectQuestionViewController
    case .date:
      return selectQuestionViewController
    case .peopleCount:
      return selectQuestionViewController
    default:
      return selectQuestionViewController
    }
  }
}

// MARK: - CreateMeetingChildViewControllerDelegate

extension CreateMeetingViewController: CreateMeetingChildViewControllerDelegate {
  func checkValidation(index:Int, state: Bool) {
    isNextButtonEnable[index] = state
    nextButton.isEnabled = isNextButtonEnable.contains(false) ? false : true
  }
}

// MARK: - Keyboard

extension CreateMeetingViewController {
  func registerKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                             name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                             name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  func removeKeyboardNotification() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc
  func keyboardWillShow(_ sender: Notification) {
    if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let keyboardHeight: CGFloat = keyboardSize.height
      nextButton.snp.updateConstraints {
        $0.bottom.equalToSuperview().inset(keyboardHeight + 26)
      }
      view.layoutIfNeeded()
    }
  }
  
  @objc
  func keyboardWillHide(_ sender: Notification) {
    nextButton.snp.updateConstraints {
      $0.bottom.equalToSuperview().inset(26)
    }
    view.layoutIfNeeded()
  }
}

// MARK: - UIScrollViewDelegate

extension CreateMeetingViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    let page = Int(round(scrollView.contentOffset.x / width))
    currentPage = page
  }
}