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
        case cdnURL = "cdnURL"
        case cartItems = "cart_item"
    }
}

// MARK: - CartItem
struct CartItem: Codable {
    let cartItemID: Int
    let userID: Int
    let mproductID: Int
    var quantity: Int
    let status: String
    let createdAt: String
    let updatedAt: String
    let product: Products

    enum CodingKeys: String, CodingKey {
        case cartItemID = "cart_item_id"
        case userID = "user_id"
        case mproductID = "mproduct_id"
        case quantity, status
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case product = "product"
    }
}

