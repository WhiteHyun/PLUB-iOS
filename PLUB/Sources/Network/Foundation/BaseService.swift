//
//  BaseService.swift
//  PLUB
//
//  Created by 홍승현 on 2023/01/13.
//

import Foundation

import Alamofire
import Then

extension Session: Then { }

class BaseService {
  let manager = Session(configuration: .af.default.then {
    $0.timeoutIntervalForRequest = NetworkEnvironment.requestTimeout
    $0.timeoutIntervalForResource = NetworkEnvironment.resourceTimeout
  })
}

// MARK: - Network Enum Cases

extension BaseService {
  
  enum PLUBError: Error {
    
    /// 경로 에러, path가 잘못된 경우
    case pathError
    
    /// 요청 값에 문제가 발생한 경우 발생되는 에러입니다.
    ///
    /// 400~499 대의 응답코드가 이 에러에 속합니다.
    case requestError
    
    /// 서버에 문제가 생겼을 때 발생됩니다.
    ///
    /// 500번대 응답코드가 이 에러에 속합니다.
    case serverError
    
    /// 사용자의 네트워크에 문제가 있어 값을 가져오지 못하는 경우
    case networkError
  }
}
