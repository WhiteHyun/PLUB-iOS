//
//  ParameterType.swift
//  PLUB
//
//  Created by 홍승현 on 2023/01/13.
//

import Foundation

enum ParameterType {
  
  /// 빈 평문입니다.
  ///
  /// 아무런 정보 값 없이 요청할 때 사용됩니다.
  case plain
  
  /// query를 설정합니다.
  ///
  /// query문으로 요청값을 전달하고 싶을 때 사용됩니다.
  case query([String: Any])
  
  /// body값을 설정합니다.
  ///
  /// `post`요청과 같이 body-field에 무언가를 담아 보내야하는 경우 사용됩니다.
  case body([String: Any])
}
