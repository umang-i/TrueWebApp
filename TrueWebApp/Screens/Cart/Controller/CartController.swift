//
//  CartController.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit

class CartController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var bottomSpendLabel: UILabel!
    @IBOutlet weak var price3Label: UILabel!
    @IBOutlet weak var price2Label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var cartScrollView: UIScrollView!
    var tableViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
    var cartItemss : [CartItem] = []
 
    private var postCartItems: [[String: Any]] {
           get {
               UserDefaults.standard.array(forKey: "cart") as? [[String: Any]] ?? []
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setnavBar()
        CartManager.shared.loadCartFromLocalStorage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartOnServer()
        updateCartSummary()
    }
    
    @objc func updateCartOnServer() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"), !authToken.isEmpty else {
            print("Error: User not logged in.")
            return
        }

        guard let cartData = UserDefaults.standard.data(forKey: "cart"),
              let localCartItems = try? JSONSerialization.jsonObject(with: cartData, options: []) as? [[String: Any]],
              !localCartItems.isEmpty else {
            self.fetchCartItems()
            print("Cart is empty, no need to update.")
            return
        }

        // Fetch existing cart items from server
        ApiService().fetchCartItems { result in
            switch result {
            case .success(let cartResponse):
                print("Fetched Server Cart Items:", cartResponse.cartItems)
                
                // Create a dictionary of existing cart items by product ID for easy lookup
                var combinedCartItems = cartResponse.cartItems

                for localItem in localCartItems {
                    if let localProductId = localItem["mproduct_id"] as? Int {
                        if let index = combinedCartItems.firstIndex(where: { $0.mproductID == localProductId }) {
                            // Update quantity if the product already exists in the server cart
                            combinedCartItems[index].quantity = localItem["quantity"] as? Int ?? 1
                        } else {
                            let newProduct = Products(
                                mproduct_id: localProductId,
                                mproduct_title: localItem["title"] as? String ?? "",
                                price: localItem["price"] as? Double ?? 0.0
                            )

                            // Create a new CartItem and append
                            if let quantity = localItem["quantity"] as? Int {
                                let newItem = CartItem(
                                    cartItemID: 0, // New item, no ID yet
                                    userID: 0, // Will be set on the server
                                    mproductID: localProductId,
                                    quantity: quantity,
                                    status: "active",
                                    createdAt: "",
                                    updatedAt: "",
                                    product: newProduct
                                )
                                combinedCartItems.append(newItem)
                            }
                        }
                    }
                }

                // Send combined cart to server
                self.sendUpdatedCartToServer(cartItems: combinedCartItems, authToken: authToken)
                
            case .failure(let error):
                print("Error fetching cart items:", error.localizedDescription)
            }
        }
    }

    // Helper method to send updated cart to server
    private func sendUpdatedCartToServer(cartItems: [CartItem], authToken: String) {
        let url = URL(string: "https://goappadmin.zapto.org/api/cart-item/update")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        // Convert CartItem model array to dictionary array
        let cartItemsDict = cartItems.map { item in
            return [
                "mproduct_id": item.mproductID,
                "quantity": item.quantity,
            ]
        }

        let requestBody: [String: Any] = ["cart": cartItemsDict]
        print("Updating Cart on Server:", requestBody)
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating cart:", error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Cart updated successfully on server.")
                UserDefaults.standard.removeObject(forKey: "cart")
                DispatchQueue.main.async {
                    self.fetchCartItems()
                    self.refreshCartData()
                    self.updateCartSummary()
                }
            } else {
                print("Failed to update cart:", response as Any)
            }
        }.resume()
    }
    
    @objc private func refreshCartData() {
            cartTableView.reloadData()
            updateTableViewHeight()
        }
    
    func setTableView() {
            cartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
            cartTableView.delegate = self
            cartTableView.dataSource = self
            cartTableView.separatorStyle = .none
            cartTableView.rowHeight = UITableView.automaticDimension
            cartTableView.isScrollEnabled = false
            tableViewHeightConstraint = cartTableView.heightAnchor.constraint(equalToConstant: 0)
            tableViewHeightConstraint?.isActive = true
            amountView.layer.shadowColor = UIColor.black.cgColor
            amountView.layer.shadowOffset = CGSize(width: 0, height: -3)
            amountView.layer.shadowOpacity = 0.5
            amountView.layer.shadowRadius = 4.0
            amountView.layer.masksToBounds = false
            updateTableViewHeight() // Update height after setting up
        }

        func updateTableViewHeight() {
            cartTableView.layoutIfNeeded()
            var totalHeight: CGFloat = 0
            for section in 0..<cartTableView.numberOfSections {
                for row in 0..<cartTableView.numberOfRows(inSection: section) {
                    let indexPath = IndexPath(row: row, section: section)
                    totalHeight += cartTableView.rectForRow(at: indexPath).height
                }
            }
            tableViewHeightConstraint?.constant = totalHeight + 200
        }
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Cart")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            // Background View Constraints (covers top of the screen)
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed

            // CustomNavBar Constraints
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @IBAction func checkoutButtonAction(_ sender: Any) {
        let vc = CheckOutController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cartItemss.count
    }
    
    // Number of rows should be equal to the number of cart items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        print("Fetched Cart Item:", cartItemss[indexPath.section])
        cell.setCell(cartItem: cartItemss[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        updateTableViewHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10
//    }
}

extension CartController: CartCellDelegate {
    func didUpdateQuantity(in cell: CartCell, quantity: Int) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        
        cartItemss[indexPath.section].quantity = quantity
        updateCartSummary()
        saveCartLocally()
    }
    
    func didTapDeleteButton(in cell: CartCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        cartItemss.remove(at: indexPath.section)
        cartTableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
        updateTableViewHeight()
        updateCartSummary()
        saveCartLocally() // Save immediately
    }

    private func updateCartSummary() {
      //  let totalUnits = cartItemss.reduce(0) { $0 + $1.quantity }
        let totalUnits = cartItemss.count
        let totalPrice = cartItemss.reduce(into: 0.0) { $0 += ($1.product.price * Double($1.quantity)) }
        let comparedPrice = cartItemss.reduce(into: 0.0) { $0 += (($1.product.compare_price ?? 0.0) * Double($1.quantity)) }
        let costPrice = cartItemss.reduce(into: 0.0) { $0 += (($1.product.cost_price ?? 0.0) * Double($1.quantity)) }

        unitsLabel.text = "\(totalUnits) Units"
        priceLabel.text = String(format: "£%.2f", totalPrice)

        // Check for compare and cost price
        if comparedPrice > 0 {
            price2Label.text = String(format: "£%.2f", comparedPrice)
        } else {
            price2Label.text = String(format: "£%.2f", totalPrice) // Default to totalPrice if no comparedPrice
        }

        if costPrice > 0 {
            price3Label.text = String(format: "£%.2f", costPrice)
        } else {
            price3Label.text = String(format: "£%.2f", totalPrice) // Default to totalPrice if no costPrice
        }

        bottomSpendLabel.text = "Spend \(String(format: "£%.2f", totalPrice)) more for free delivery"
    }

    
    private func saveCartLocally() {
        print("Cart Items before saving:", cartItemss)
        if cartItemss.isEmpty {
            print("Cart is empty. Removing from UserDefaults.")
            UserDefaults.standard.removeObject(forKey: "cart")
        } else {
            let cartData = cartItemss.map { cartItem in
                [
                    "mproduct_id": cartItem.mproductID,
                    "quantity": cartItem.quantity
                ]
            }
            print("Saving Cart Locally:", cartData)
            UserDefaults.standard.set(cartData, forKey: "cart")
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ApiService().updateCartOnServer { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("Cart successfully updated on server.")
                } else {
                    print("Failed to update cart:", errorMessage ?? "Unknown error")
                }
            }
        }
    }
}

// CartController.swift
extension CartController {
    func fetchCartItems() {
        ApiService().fetchCartItems { [weak self] result in
            switch result {
            case .success(let cartResponse):
                print("Fetched Cart Items:", cartResponse.cartItems)
                DispatchQueue.main.async {
                    self?.cartItemss = cartResponse.cartItems
                    self?.cartTableView.reloadData()
                    self?.updateTableViewHeight()
                    self?.updateCartSummary()
                }
            case .failure(let error):
                print("Error fetching cart items:", error.localizedDescription)
            }
        }
    }
}
