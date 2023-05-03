//
//  MyPageRouter.swift
//  PLUB
//
//  Created by 김수빈 on 2023/03/13.
//

import Alamofire

enum MyPageRouter {
  case inquireMyMeeting(MyPlubbingParameter)
  case inquireMyTodo(Int, Int)
}

extension MyPageRouter: Router {
  var method: HTTPMethod {
    switch self {
    case .inquireMyMeeting, .inquireMyTodo:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .inquireMyMeeting:
      return "/plubbings/all/my"
    case .inquireMyTodo(let plubbingID, _):
      return "/plubbings/\(plubbingID)/timeline/my"
    }
  }
  
  var parameters: ParameterType {
    switch self {
    case .inquireMyMeeting(let parameter):
      return .query(parameter)
    case .inquireMyTodo(_, let cursorID):
      return .query(["cursorId": cursorID])
    }
  }
  
  var headers: HeaderType {
    switch self {
    case .inquireMyMeeting, .inquireMyTodo:
      return .withAccessToken
    }
  }
}

