//
//  CartController.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit

class CartController: UIViewController, CustomNavBarDelegate , UIGestureRecognizerDelegate{
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
    var cartNeedsUpdate = false
    
    var isLoading : Bool = true
    var isRefreshing = false
    let loaderView = CustomLoaderView()
    
    private let emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "Cart Empty"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

 
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
        setupLoaderView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBannerPan(_:)))
        panGesture.delegate = self
        cartScrollView.addGestureRecognizer(panGesture)
        view.bringSubviewToFront(loaderView)
        
        view.addSubview(emptyCartLabel)
            NSLayoutConstraint.activate([
                emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50)
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartOnServer()
        updateCartSummary()
    }
    
    private func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true
        loaderView.isUserInteractionEnabled = false

        view.addSubview(loaderView)  // ✅ make sure this comes before bringSubviewToFront
        view.bringSubviewToFront(loaderView)  // ✅ move here

        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 50),
            loaderView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func handleBannerPan(_ gesture: UIPanGestureRecognizer) {
        print("Refreshing")
        let translation = gesture.translation(in: cartScrollView)

        // Ensure it's a downward pull from the top of the scrollView
        if translation.y > 30 && cartScrollView.contentOffset.y <= 1 {
            if gesture.state == .ended && !isRefreshing {
                isRefreshing = true
                print("Pull down detected on scrollView - trigger refresh")
                handleRefresh()
            }
        }
    }

    func showLoader() {
        DispatchQueue.main.async {
            print("loader is showing")
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
        }
    }

    func hideLoader() {
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
    
    func handleRefresh() {
        print("✅ handleRefresh triggered")
        isLoading = true
        self.showLoader()
        cartTableView.reloadData()
        fetchCartItems()
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
                print("Fetched Server Cart Items:", cartResponse.cartItems.count)

                // Create a dictionary of server cart items by mvariantID
                var existingCartDict = Dictionary(uniqueKeysWithValues: cartResponse.cartItems.map { ($0.mvariantID, $0) })

                for localItem in localCartItems {
                    guard let variantID = localItem["mvariant_id"] as? Int,
                          let quantity = localItem["quantity"] as? Int else {
                        continue
                    }

                    if existingCartDict[variantID] != nil {
                        // Update quantity if item exists
                        existingCartDict[variantID]?.quantity = quantity
                    } else {
                        // Create a new item
                        let newItem = CartItem(cartItemID: 0, mvariantID: variantID, quantity: quantity, status: "active", product: Products(mproduct_id: 0, mproduct_title: "", price: 0.0))
                        existingCartDict[variantID] = newItem
                    }
                }

                let combinedItems = Array(existingCartDict.values)
                self.sendUpdatedCartToServer(cartItems: combinedItems, authToken: authToken)

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
                "mvariant_id": item.mvariantID,
                "quantity": item.quantity,
            ]
        }

        let requestBody: [String: Any] = ["cart": cartItemsDict]
        print("Updating Cart on Server:", requestBody)
        
//        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) {
//            UserDefaults.standard.set(cartItemsDict, forKey: "cart")
//                print("✅ Saved requestBody to local storage")
//            } else {
//                print("❌ Failed to serialize requestBody for local storage")
//            }
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating cart:", error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Cart updated successfully on server.")
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
            cartTableView.register(ShimmerCell.self, forCellReuseIdentifier: "ShimmerCell")
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
        if cartItemss.isEmpty == false {
            let vc = CheckOutController()
            let totalUnits = cartItemss.count
            let totalPrice = cartItemss.reduce(into: 0.0) { $0 += ($1.product.price * Double($1.quantity)) }
            let comparedPrice = cartItemss.reduce(into: 0.0) { $0 += (($1.product.compare_price ?? 0.0) * Double($1.quantity)) }
            let costPrice = cartItemss.reduce(into: 0.0) { $0 += (($1.product.cost_price ?? 0.0) * Double($1.quantity)) }

            vc.discount = "£\(comparedPrice)"
            vc.payment = "£\(totalPrice)"
            vc.vat = "£\(0.0)"
            vc.subtotal = "£\(totalPrice)"
            vc.units = "\(totalUnits)"
            vc.skus = "\(1)"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension CartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 2 : cartItemss.count
    }
    
    // Number of rows should be equal to the number of cart items
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Cell Configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell") as? ShimmerCell else {
                return UITableViewCell()
            }
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell else {
            return UITableViewCell()
        }
        cell.delegate = self
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
        emptyCartLabel.isHidden = !cartItemss.isEmpty
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
            CartManager.shared.clearCart()
        } else {
            // Prepare data for UserDefaults
            let cartData = cartItemss.map { cartItem in
                [
                    "mvariant_id": cartItem.mvariantID,
                    "quantity": cartItem.quantity
                ]
            }
            print("Saving Cart Locally:", cartData)
            UserDefaults.standard.set(cartData, forKey: "cart")
            
            // 🔄 Also update CartManager
            CartManager.shared.clearCart()
            for item in cartItemss {
                CartManager.shared.updateCartItem(
                    mVariantId: item.mvariantID,
                    quantity: item.quantity, price: item.product.price,
                )
            }
        }
    }
  //  var cartNeedsUpdate = false
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        CartManager.shared.saveCartToLocalStorage()

        let requestBody = CartManager.shared.getCartRequestBody()
        print("🧪 Final cart payload:", requestBody)

        ApiService().updateCartOnServer { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("Cart successfully updated on server.")
                    self.cartNeedsUpdate = false // reset flag
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
        ApiService().fetchCartItems { result in
            DispatchQueue.main.async {
                self.hideLoader()
                self.isLoading = false
                self.isRefreshing = false

                switch result {
                case .success(let cartResponse):
                    self.cartItemss = cartResponse.cartItems
                    self.cartTableView.reloadData()
                    self.updateCartSummary()
                    self.updateTableViewHeight()

                case .failure(let error):
                    print("Fetch failed:", error)
                }
            }
        }
    }
}
