//
//  OrderModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 21/03/25.
//

//import Foundation
//
//struct FetchOrdersResponse: Codable {
//    let status: Bool
//    let message: String
//    let orders: [Order]?
//}
//
//struct Order: Codable {
//    let orderId: Int
//    let userId: Int
//    let totalAmount: String
//    let status: String
//    let userCompanyAddressId: Int
//    let deliveryMethodId: Int
//    let createdAt: String
//    let updatedAt: String
//    let items: [OrderItems]
//    let user: OrderUser
//
//    enum CodingKeys: String, CodingKey {
//        case orderId = "order_id"
//        case userId = "user_id"
//        case totalAmount = "total_amount"
//        case status
//        case userCompanyAddressId = "user_company_address_id"
//        case deliveryMethodId = "delivery_method_id"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case items
//        case user
//    }
//}
//
//struct OrderItems: Codable {
//    let orderItemId: Int
//    let orderId: Int
//    let mvariantId: Int
//    let quantity: Int
//    let unitPrice: String
//    let createdAt: String
//    let updatedAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case orderItemId = "order_item_id"
//        case orderId = "order_id"
//        case mvariantId = "mvariant_id"
//        case quantity
//        case unitPrice = "unit_price"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//    }
//}
//
//struct OrderUser: Codable {
//    let id: Int
//    let name: String
//    let email: String
//}
//
//
//struct SingleOrderResponse: Codable {
//    let status: Bool
//    let message: String
//    let order: Order
//}

import Foundation

struct FetchOrdersResponse: Codable {
    let status: Bool
    let message: String
    let orders: [Order]
}

struct Order: Codable {
    let orderId: Int
    let user: OrderUser
    let orderDate: String
    let units: Int
    let paymentStatus: String
    let fulfillmentStatus: String
    let skus: Int
    let delivery: OrderDelivery
    let summary: OrderSummary
    let items: [OrderItems]

    enum CodingKeys: String, CodingKey {
        case orderId = "order_id"
        case user
        case orderDate = "order_date"
        case units
        case paymentStatus = "payment_status"
        case fulfillmentStatus = "fulfillment_status"
        case skus
        case delivery
        case summary
        case items
    }
}

struct OrderUser: Codable {
    let id: Int
    let name: String
    let email: String
}

struct OrderDelivery: Codable {
    let method: String
    let address: String
    let address_id: Int
    let method_id: Int
}

struct OrderSummary: Codable {
    let subtotal: Double
    let walletDiscount: Double
    let couponDiscount: Double
    let deliveryCost: Double
    let vat: Double
    let paymentTotal: Double

    enum CodingKeys: String, CodingKey {
        case subtotal
        case walletDiscount = "wallet_discount"
        case couponDiscount = "coupon_discount"
        case deliveryCost = "delivery_cost"
        case vat
        case paymentTotal = "payment_total"
    }
}

struct OrderItems: Codable {
    let orderItemId: Int
    let mvariantId: Int
    let quantity: Int
    let unitPrice: Double
    let variant: Variant
    let product: Product

    enum CodingKeys: String, CodingKey {
        case orderItemId = "order_item_id"
        case mvariantId = "mvariant_id"
        case quantity
        case unitPrice = "unit_price"
        case variant
        case product
    }
}

struct Variant: Codable {
    let sku: String
    let image: String?
    let price: Double
    let comparePrice: Double
    let costPrice: Double
    let options: [String]
    let optionValue: [String: String]

    enum CodingKeys: String, CodingKey {
        case sku, image, price
        case comparePrice = "compare_price"
        case costPrice = "cost_price"
        case options
        case optionValue = "option_value"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sku = try container.decode(String.self, forKey: .sku)
        image = try? container.decodeIfPresent(String.self, forKey: .image)
        price = try container.decode(Double.self, forKey: .price)
        comparePrice = try container.decode(Double.self, forKey: .comparePrice)
        costPrice = try container.decode(Double.self, forKey: .costPrice)
        options = try container.decode([String].self, forKey: .options)

        // Try to decode dictionary, fallback to empty dictionary if it fails
        if let dict = try? container.decode([String: String].self, forKey: .optionValue) {
            optionValue = dict
        } else {
            optionValue = [:]
        }
    }
}


struct Product: Codable {
    let mproductId: Int
    let mproductTitle: String
    let mproductSlug: String
    let mproductImage: String?

    enum CodingKeys: String, CodingKey {
        case mproductId = "mproduct_id"
        case mproductTitle = "mproduct_title"
        case mproductSlug = "mproduct_slug"
        case mproductImage = "mproduct_image"
    }
}


struct SingleOrderResponse: Codable {
    let status: Bool
    let message: String
    let order: Order
}
