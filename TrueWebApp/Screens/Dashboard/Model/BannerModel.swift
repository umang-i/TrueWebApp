//
//  BannerModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 16/06/25.
//

import Foundation

struct BigSlidersResponse: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let bigSliders: [BigSlider]
}

struct BigSlider: Codable {
    let id: Int
    let name: String
    let image: String
    let position: Int

    // Optional linking properties
    let mainMcatId: Int?
    let mcatId: Int?
    let msubcatId: Int?
    let mproductId: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id = "home_large_banner_id"
        case name = "home_large_banner_name"
        case image = "home_large_banner_image"
        case position = "home_large_banner_position"
        case mainMcatId = "main_mcat_id"
        case mcatId = "mcat_id"
        case msubcatId = "msubcat_id"
        case mproductId = "mproduct_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}


// MARK: - FruitSlidersResponse
struct FruitSlidersResponse: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let fruitSliders: [FruitSlider]

    enum CodingKeys: String, CodingKey {
        case status, message
        case cdnURL = "cdnURL"
        case fruitSliders = "fruitSliders"
    }
}

// MARK: - FruitSlider
struct FruitSlider: Codable {
    let id: Int
    let name: String
    let imagePath: String
    let position: Int?

    enum CodingKeys: String, CodingKey {
        case id = "home_fruit_banner_id"
        case name = "home_fruit_banner_name"
        case imagePath = "home_fruit_banner_image"
        case position = "home_fruit_banner_position"
    }
}

// MARK: - DealsSlidersResponse
struct DealsSlidersResponse: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let dealsSliders: [DealSlider]

    enum CodingKeys: String, CodingKey {
        case status, message
        case cdnURL
        case dealsSliders
    }
}

// MARK: - DealSlider
struct DealSlider: Codable {
    let id: Int
    let name: String
    let imagePath: String
    let position: Int?

    enum CodingKeys: String, CodingKey {
        case id = "home_explore_deal_banner_id"
        case name = "home_explore_deal_banner_name"
        case imagePath = "home_explore_deal_banner_image"
        case position = "home_explore_deal_banner_position"
    }
}
