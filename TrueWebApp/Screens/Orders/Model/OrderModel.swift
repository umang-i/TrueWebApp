//
//  OrderModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 21/03/25.
//

import Foundation

struct Order {
    let units: Int
    let sku: String
    let deliveryAddress: String
    let subtotal: Double
    let walletDiscount: Double
    let couponDiscount: Double
    let deliveryCharge: Double
    let vat: Double // 20% of subtotal
    let paymentTotal: Double

    init(units: Int, sku: String, deliveryAddress: String, subtotal: Double, walletDiscount: Double, couponDiscount: Double, deliveryCharge: Double) {
        self.units = units
        self.sku = sku
        self.deliveryAddress = deliveryAddress
        self.subtotal = subtotal
        self.walletDiscount = walletDiscount
        self.couponDiscount = couponDiscount
        self.deliveryCharge = deliveryCharge
        self.vat = subtotal * 0.20 // VAT 20%
        self.paymentTotal = (subtotal + self.vat + deliveryCharge) - (walletDiscount + couponDiscount)
    }
}

