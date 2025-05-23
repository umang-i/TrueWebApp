//
//  GridCells + Extension.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 13/05/25.
//

import Foundation

// MARK: - Cart Management
extension GridCell {
    
    func saveCartItem(productId: Int, quantity: Int, unitPrice: Double) {
        var cart = fetchCartItems()

        if let index = cart.firstIndex(where: { $0["mproduct_id"] as? Int == productId }) {
            if quantity > 0 {
                cart[index]["quantity"] = quantity
                cart[index]["unitPrice"] = unitPrice
            } else {
                cart.remove(at: index) // Remove item if quantity is zero
            }
        } else if quantity > 0 {
            cart.append([
                "mproduct_id": productId,
                "quantity": quantity,
                "unitPrice": unitPrice
            ])
        }

        saveCartToLocal(cart)
        
        // Notify CartController to update server or UI
        NotificationCenter.default.post(name: NSNotification.Name("CartUpdated"), object: nil)
    }

    func fetchCartItems() -> [[String: Any]] {
        if let cartData = UserDefaults.standard.data(forKey: "cart"),
           let cart = try? JSONSerialization.jsonObject(with: cartData, options: []) as? [[String: Any]] {
            return cart
        }
        return []
    }

    func saveCartToLocal(_ cart: [[String: Any]]) {
        if let cartData = try? JSONSerialization.data(withJSONObject: cart, options: []) {
            UserDefaults.standard.set(cartData, forKey: "cart")
        }
    }
}
