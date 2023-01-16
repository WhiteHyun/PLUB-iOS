//
//  BaseService.swift
//  PLUB
//
//  Created by 홍승현 on 2023/01/13.
//

import Foundation

import Alamofire
import RxCocoa
import RxSwift
import Then

extension Session: Then { }

class BaseService {
  
  /// Network Response에 대해 값을 검증하고 그 결과값을 리턴합니다.
  /// - Parameters:
  ///   - statusCode: http 상태 코드
  ///   - data: 응답값으로 받아온 `Data`
  ///   - type: Data 내부를 구성하는 타입
  /// - Returns: GeneralResponse 또는 Plub Error
  ///
  /// 해당 메서드는 검증을 위해 사용됩니다.
  /// 요청값을 전달하고 응답받은 값을 처리하고 싶은 경우 `requestObject(_:type:)`을 사용해주세요.
  func evaluateStatus<T: Codable>(
    by statusCode: Int,
    _ data: Data,
    type: T.Type
  ) -> NetworkResult<GeneralResponse<T>> {
    guard let decodedData = try? JSONDecoder().decode(GeneralResponse<T>.self, from: data) else {
      return .pathError
    }
    switch statusCode {
    case 200..<300:
      return .success(decodedData)
    case 400..<500:
      return .requestError(decodedData)
    case 500:
      return .serverError
    default:
      return .networkError
    }
  }
  
  /// PLUB 서버에 필요한 값을 동봉하여 요청합니다.
  /// - Parameters:
  ///   - target: Router를 채택한 인스턴스(instance)
  ///   - type: 응답 값에 들어오는 `data`를 파싱할 모델
  func sendRequest<T: Codable>(
    _ router: Router,
    type: T.Type = EmptyModel.self
  ) -> Observable<NetworkResult<GeneralResponse<T>>> {
    Single.create { observer in
      AF.request(router).responseData { response in
        switch response.result {
        case .success(let data):
          guard let statusCode = response.response?.statusCode else {
            fatalError("statusCode가 없는 응답값????")
          }
          // PLUBError와 Success(GeneralResponse<T>)가 같이 들어가 있음
          observer(.success(self.evaluateStatus(by: statusCode, data, type: type)))
        case .failure(let error):
          observer(.failure(error)) // Alamofire Error
        }
      }
      return Disposables.create()
    }
    .asObservable()
  }
}

// MARK: - Empty Model

extension BaseService {
  struct EmptyModel: Codable { }
}