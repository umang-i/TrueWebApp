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
        
    func updateCartItem(productId: Int, quantity: Int, price: Double) {
        guard quantity >= 0, price < 10000 else {
            print("❌ Invalid item: quantity \(quantity), price \(price)")
            return
        }

        queue.sync {
            if quantity > 0 {
                cartItems[productId] = (quantity, price) // make sure price is unitPrice
            } else {
                cartItems.removeValue(forKey: productId)
            }
            saveCartToLocalStorage()
        }

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
            NotificationCenter.default.post(name: .priceUpdated, object: nil)
        }
    }
        
    func saveCartToLocalStorage() {
        let cartArray = cartItems.map { (productId, item) in
            return [
                "productId": productId,
                "quantity": item.quantity,
                "unitPrice": (Int(item.price) / item.quantity) // This should be unit price only!
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
            return
        }

        cartItems.removeAll()

        for item in array {
            if let productId = item["productId"] as? Int,
               let quantity = item["quantity"] as? Int,
               let unitPrice = item["unitPrice"] as? Double {

                // 🚫 Skip if unitPrice looks like a total
                let likelyUnit = unitPrice / Double(quantity)
                if quantity > 1 && abs(unitPrice - likelyUnit) > 0.01 {
                    print("⚠️ Skipping item \(productId) with suspicious price \(unitPrice)")
                    continue
                }

                cartItems[productId] = (quantity, unitPrice)
            }
        }
        print("✅ Cart loaded from local storage:", cartItems)
    }
    

//    func updateCartItem(productId: Int, quantity: Int, price: Double) {
//        queue.sync {
//            if quantity > 0 {
//                cartItems[productId] = (quantity, price)
//            } else {
//                cartItems.removeValue(forKey: productId)
//            }
//        }
//        DispatchQueue.main.async {
//            NotificationCenter.default.post(name: .cartUpdated, object: nil)
//            NotificationCenter.default.post(name: .priceUpdated, object: nil)
//        }
//    }

    // Get total number of items in cart
    func getTotalQuantity() -> Int {
        return cartItems.keys.count
    }

    // Get total price of all items in cart
//    func getTotalPrice() -> Double {
//        queue.sync {
//            return cartItems.values.reduce(0.0) { total, item in
//                print(item.quantity)
//                print("total \(total)")
//                print(total + (Double(item.quantity) * item.price))
//                return total + (Double(item.quantity) * item.price)
//            }
//        }
//    }
    
//    func getTotalPrice() -> Double {
//        queue.sync {
//            print("Cart contents:")
//            for (key, item) in cartItems {
//                print("Item: \(key), quantity: \(item.quantity), price: \(item.price)")
//            }
//
//            let total = cartItems.values.reduce(0.0) { total, item in
//                let subtotal = Double(item.quantity) * item.price  // Multiply unit price by quantity!
//                print("subtotal = \(subtotal), running total = \(total + subtotal)")
//                return total + subtotal
//            }
//
//            return round(total * 100) / 100  // Round to 2 decimals
//        }
//    }
    
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
        NotificationCenter.default.post(name: .cartUpdated, object: nil)
        NotificationCenter.default.post(name: .priceUpdated, object: nil)
    }
}

// Notifications
extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
    static let priceUpdated = Notification.Name("priceUpdated")
}

