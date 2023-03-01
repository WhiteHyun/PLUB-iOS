//
//  MeetingViewModel.swift
//  PLUB
//
//  Created by 김수빈 on 2023/03/01.
//

import Foundation

import RxSwift
import RxCocoa

final class MeetingViewModel {
  private let disposeBag = DisposeBag()

  // Input

  
  // Output
  
  init() {
    fetchMyMeeting()
  }
  
  private func fetchMyMeeting() {
    MeetingService.shared
      .inquireMyMeeting(
        isHost: true
      )
      .withUnretained(self)
      .subscribe(onNext: { owner, result in
        switch result {
        case .success(let model):
          guard let data = model.data else { return }
          print(data)
        default: break// TODO: 수빈 - PLUB 에러 Alert 띄우기
        }
      })
      .disposed(by: disposeBag)
  }
}
