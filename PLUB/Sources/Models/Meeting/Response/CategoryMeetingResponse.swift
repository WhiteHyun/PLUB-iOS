//
//  CategoryMeetingResponse.swift
//  PLUB
//
//  Created by 이건준 on 2023/01/20.
//

import Foundation

struct CategoryMeetingResponse: Codable {
  let totalPages: Int
  let totalElements: Int
  let last: Bool
  let content: [Content]
  
  enum CodingKeys: String, CodingKey {
    case totalPages, totalElements, last, content
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    
    totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
    totalElements = try values.decodeIfPresent(Int.self, forKey: .totalElements) ?? 0
    last = try values.decodeIfPresent(Bool.self, forKey: .last) ?? false
    content = try values.decodeIfPresent([Content].self, forKey: .content) ?? []
  }
}

struct Content: Codable {
  let plubbingID: Int
  let name: String
  let title: String
  let mainImage: String?
  let introduce: String
  let time: String
  let days: [String]
  let address: String
  let roadAddress: String
  let placeName: String
  let placePositionX: Double
  let placePositionY: Double
  let curAccountNum: Int
  let remainAccountNum: Int
  let isBookmarked: Bool
  let isHost: Bool
  
  enum CodingKeys: String, CodingKey {
    case plubbingID = "plubbingId"
    case name, title, mainImage, introduce, time, days, address, roadAddress, placeName, placePositionX, placePositionY, curAccountNum, remainAccountNum, isBookmarked, isHost
  }
}
