//
//  RequestBookmarkResponse.swift
//  PLUB
//
//  Created by 이건준 on 2023/01/29.
//

import Foundation

struct RequestBookmarkResponse: Codable, Equatable {
  let plubbingID: Int
  let isBookmarked: Bool
  
  enum CodingKeys: String, CodingKey {
    case plubbingID = "plubbingId"
    case isBookmarked
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    plubbingID = try values.decodeIfPresent(Int.self, forKey: .plubbingID) ?? -1
    isBookmarked = try values.decodeIfPresent(Bool.self, forKey: .isBookmarked) ?? false
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.plubbingID == rhs.plubbingID && lhs.isBookmarked == rhs.isBookmarked
  }
}
