//
//  CartManger.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 19/05/25.
//

import Foundation

class CartManager {
    static let shared = CartManager()
    private init() {}

    // Store cart items as [ProductID: (Quantity, Price)]
    private var cartItems: [Int: (quantity: Int, price: Double)] = [:]

    private let queue = DispatchQueue(label: "com.app.CartManagerQueue")
    
   // private let cartStorageKey = "savedCart"
        
    func updateCartItem(mVariantId: Int, quantity: Int, price: Double) {
        guard quantity >= 0, price < 10000 else {
            print("❌ Invalid item: quantity \(quantity), price \(price)")
            return
        }

        queue.sync {
            if quantity > 0 {
                cartItems[mVariantId] = (quantity, price) // make sure price is unitPrice
            } else {
                cartItems.removeValue(forKey: mVariantId)
            }
            saveCartToLocalStorage()
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
            NotificationCenter.default.post(name: .priceUpdated, object: nil)
        }
    }
        
    func saveCartToLocalStorage() {
        let cartArray = cartItems.map { (mvariantId, item) in
            return [
                "mvariant_id": mvariantId,
                "quantity": item.quantity,
                "unitPrice": item.price
              //  "unitPrice": (Int(item.price) / item.quantity) // This should be unit price only!
            ]
        }

        if let data = try? JSONSerialization.data(withJSONObject: cartArray, options: []) {
            UserDefaults.standard.set(data, forKey: "cart")
            print("✅ Cart saved to local storage:", cartArray)
        }
    }
        
        // ✅ Load cart from UserDefaults on init
    func loadCartFromLocalStorage() {
        guard let data = UserDefaults.standard.data(forKey: "cart"),
              let array = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            //completion(false, "Error: No cart data found.")
            return
        }

        cartItems.removeAll()

        for item in array {
            if let productId = item["mvariant_id"] as? Int,
               let quantity = item["quantity"] as? Int,
               let unitPrice = item["unitPrice"] as? Double {

                // 🚫 Skip if unitPrice looks like a total
//                let likelyUnit = unitPrice / Double(quantity)
//                if quantity > 1 && abs(unitPrice - likelyUnit) > 0.01 {
//                    print("⚠️ Skipping item \(productId) with suspicious price \(unitPrice)")
//                    continue
//                }

                cartItems[productId] = (quantity, unitPrice)
            }
        }
        print("✅ Cart loaded from local storage:", cartItems)
    }

    func getCartRequestBody() -> [String: Any] {
        let cartArray = cartItems.map { (mvariantId, item) in
            return [
                "mvariant_id": mvariantId,
                "quantity": item.quantity,
                "unitPrice": item.price
            ]
        }

        return ["cart": cartArray]
    }

    // Get total number of items in cart
    func getTotalQuantity() -> Int {
        return cartItems.keys.count
    }
    
    func getTotalPrice() -> Double {
        queue.sync {
            print("Cart contents:")
            for (key, item) in cartItems {
                print("Item: \(key), quantity: \(item.quantity), price: \(item.price)")
            }

            var runningTotal: Double = 0.0

            for item in cartItems.values {
                let subtotal = Double(item.quantity) * item.price
                runningTotal += subtotal
                print("subtotal = \(subtotal), running total = \(runningTotal)")
            }

            let roundedTotal = round(runningTotal * 100) / 100
            print("Final total (rounded): \(roundedTotal)")
            return roundedTotal
        }
    }

    
    func getAllCartItems() -> [Int: (quantity: Int, price: Double)] {
            return cartItems
        }

    // Get price of a specific product (optional)
    func getProductPrice(productId: Int) -> Double? {
        return cartItems[productId]?.price
    }

    // Get quantity of a specific product (optional)
    func getProductQuantity(productId: Int) -> Int? {
        return cartItems[productId]?.quantity
    }

    // Clear entire cart
    func clearCart() {
        cartItems.removeAll()
        saveCartToLocalStorage() // ✅ Overwrite local storage with empty cart
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        NotificationCenter.default.post(name: .priceUpdated, object: nil)
    }
}

// Notifications
extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
    static let priceUpdated = Notification.Name("priceUpdated")
}

