//
//  DeliveryMethod.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 03/06/25.
//

struct MethodDeliveryResponse: Codable {
    let status: Bool
    let message: String
    let delivery_methods: [MethodDelivery]?
}

struct MethodDelivery: Codable {
    let delivery_method_id: Int
    let delivery_method_name: String
    let delivery_method_amount: String
    let method_status: String
    let created_at: String
    let updated_at: String
}

struct OrderItem: Codable {
    let mvariant_id: Int
    let quantity: Int
    let unit_price: Double
}

struct OrderRequest: Codable {
    let items: [OrderItem]
    let user_company_address_id: Int
    let delivery_method_id: Int
    let coupon_discount : Double
    let wallet_discount : Double
}

struct OrderResponse: Codable {
    let status: Bool
    let message: String
    let orders: [OrdersDetail]?
}

struct OrdersDetail: Codable {
    let order_id: Int
    let user_id: Int
    let total_amount: Double
    let status: String
    let user_company_address_id: Int
    let delivery_method_id: Int
    let created_at: String
    let updated_at: String
    let orders: [Orders]
}

struct Orders: Codable {
    let order_item_id: Int
    let order_id: Int
    let mvariant_id: Int
    let quantity: Int
    let unit_price: Double
}


struct CouponResponse: Codable {
    let status: Bool
    let message: String
    let originalTotal: Double
    let discount: Double
    let newTotal: Double
    let couponCode: String

    enum CodingKeys: String, CodingKey {
        case status, message
        case originalTotal = "original_total"
        case discount
        case newTotal = "new_total"
        case couponCode = "coupon_code"
    }
}
