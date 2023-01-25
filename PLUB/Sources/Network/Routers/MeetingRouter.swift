//
//  CategoryRouter.swift
//  PLUB
//
//  Created by 이건준 on 2023/01/19.
//

import Alamofire

enum MeetingRouter {
  case inquireCategoryMeeting(String, Int)
  case inquireRecommendationMeeting
}

extension MeetingRouter: Router {
  var method: HTTPMethod {
    switch self {
    case .inquireCategoryMeeting, .inquireRecommendationMeeting:
      return .get
    }
  }
  
  var path: String {
    switch self {
    case .inquireCategoryMeeting(let categoryId, _):
      return "/plubbings/categories/\(categoryId)"
    case .inquireRecommendationMeeting:
      return "/plubbings/recommendation"
    }
  }
  
  var parameters: ParameterType {
    switch self {
    case .inquireCategoryMeeting(_, let page):
      return .query(["page": page])
    case .inquireRecommendationMeeting:
      return .plain
    }
  }
  
  var headers: HeaderType {
    switch self {
    case .inquireCategoryMeeting, .inquireRecommendationMeeting:
      return .withAccessToken
    }
  }
}

