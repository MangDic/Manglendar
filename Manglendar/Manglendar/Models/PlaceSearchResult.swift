//
//  PlaceSearchResult.swift
//  Manglendar
//
//  Created by 이명직 on 2023/04/11.
//

struct PlaceSearchResult: Codable {
    let meta: Meta
    let documents: [PlaceData]
}


struct Meta: Codable {
    let same_name: SameName
    let pageable_count: Int
    let total_count: Int
    let is_end: Bool
}

struct SameName: Codable {
    let region: [String]
    let keyword: String
    let selected_region: String
}

struct PlaceData: Codable, Equatable, Hashable {
    let place_name: String
    let distance: String
    let place_url: String
    let category_name: String
    let address_name: String
    let road_address_name: String
    let id: String
    let phone: String
    let category_group_code: String
    let category_group_name: String
    let x: String
    let y: String
}
