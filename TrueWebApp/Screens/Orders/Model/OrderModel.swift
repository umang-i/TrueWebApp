//
//  OrderModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 21/03/25.
//

import Foundation

struct FetchOrdersResponse: Codable {
    let status: Bool
    let message: String
    let orders: [Order]?
}

struct Order: Codable {
    let orderId: Int
    let userId: Int
    let totalAmount: String
    let status: String
    let userCompanyAddressId: Int
    let deliveryMethodId: Int
    let createdAt: String
    let updatedAt: String
    let items: [OrderItems]
    let user: OrderUser

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case userId = "user_id"
        case totalAmount = "total_amount"
        case status
        case userCompanyAddressId = "user_company_address_id"
        case deliveryMethodId = "delivery_method_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case items
        case user
    }
}

struct OrderItems: Codable {
    let orderItemId: Int
    let orderId: Int
    let mvariantId: Int
    let quantity: Int
    let unitPrice: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case orderItemId = "order_item_id"
        case orderId = "order_id"
        case mvariantId = "mvariant_id"
        case quantity
        case unitPrice = "unit_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct OrderUser: Codable {
    let id: Int
    let name: String
    let email: String
}


struct SingleOrderResponse: Codable {
    let status: Bool
    let message: String
    let order: Order
}
