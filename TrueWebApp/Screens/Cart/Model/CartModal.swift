//
//  CartModal.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 14/05/25.
//

import Foundation

struct CartResponse: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let cartItems: [CartItem]

    enum CodingKeys: String, CodingKey {
        case status, message
        case cdnURL
        case cartItems = "cart_item"
    }
}

// MARK: - CartItem
struct CartItem: Codable {
    let cartItemID: Int
    let mvariantID: Int
    var quantity: Int
    let status: String
    let product: Products

    enum CodingKeys: String, CodingKey {
        case cartItemID = "cart_item_id"
        case mvariantID = "mvariant_id"
        case quantity, status, product
    }
}

// MARK: - CartItem Upload
//
//struct CartUpdateRequest: Codable {
//    let cart: [CartItemPayload]
//}
//
//struct CartItemPayload: Codable {
//    let mvariant_id: Int
//    let quantity: Int
//}

