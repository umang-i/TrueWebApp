//
//  TabBarController.swift
//  TrueApp
//
//  Created by Umang Kedan on 19/02/25.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    let appBarView = UIView()
    let appBarImageView = UIImageView()
    let cartImageView = UIImageView()
    let appBarLabel = UILabel()
    let balanceLabel = UILabel()
    let overlayView = UIView()
    let badgeLabel = UILabel()
    
    var appBarImageLeadingConstraint: NSLayoutConstraint!
    var appBarImageCenterConstraint: NSLayoutConstraint!
    var appBarImageWidthConstraint: NSLayoutConstraint!
    var appBarImageHeightConstraint: NSLayoutConstraint!
    
    var cartCount : Int?
    var price : Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
        setupAppBar()
        // FetchCart()
        updateAppBar(for: selectedIndex)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartBadge(notification:)), name: .cartUpdated, object: nil)
    }
    
    
    //    @objc private func updateCartBadge(notification: Notification? = nil) {
    //        let totalCartCount = CartManager.shared.getTotalQuantity()
    //        let totalPrice = CartManager.shared.getTotalPrice()
    //
    //        badgeLabel.text = totalCartCount > 0 ? "\(totalCartCount)" : nil
    //        badgeLabel.isHidden = totalCartCount == 0
    //        badgeLabel.backgroundColor = .customRed
    //        balanceLabel.text = "£\(String(format: "%.2f", totalPrice))"
    //    }
    
//    @objc private func updateCartBadge(notification: Notification? = nil) {
//        let initialCount = cartCount ?? 0
//        let initialPrice = price ?? 0.0
//        
//        let currentCount = CartManager.shared.getTotalQuantity()
//        let currentPrice = CartManager.shared.getTotalPrice()
//        
//        // Calculate the final values
//        let finalCount = initialCount + (currentCount - initialCount)
//        let finalPrice = initialPrice + (currentPrice - initialPrice)
//        
//        // Update labels
//        badgeLabel.text = finalCount > 0 ? "\(finalCount)" : nil
//        badgeLabel.isHidden = finalCount == 0
//        badgeLabel.backgroundColor = .customRed
//        balanceLabel.text = "£\(String(format: "%.2f", finalPrice))"
//        
//        // Update stored values
//        cartCount = finalCount
//        price = finalPrice
//    }
    
    @objc private func updateCartBadge(notification: Notification? = nil) {
        let totalCartCount = CartManager.shared.getTotalQuantity()
        let totalPrice = CartManager.shared.getTotalPrice()
        
        // Hide badge and balance if on the first tab
        let shouldHide = (selectedIndex == 0 || totalCartCount == 0)
        badgeLabel.isHidden = shouldHide
        balanceLabel.isHidden = shouldHide
        
        if !shouldHide {
            // Update Badge Label
            badgeLabel.text = "\(totalCartCount)"
            badgeLabel.backgroundColor = .customRed
            
            // Update Balance Label
            balanceLabel.text = "£\(String(format: "%.2f", totalPrice))"
        } else {
            badgeLabel.text = nil
            balanceLabel.text = nil
        }
    }

 
    func FetchCart() {
        ApiService().fetchCartItems { [weak self] result in
            switch result {
            case .success(let cartResponse):
                print("Fetched Cart Items:", cartResponse.cartItems)
                
                
                // Sync CartManager with fetched cart data
                DispatchQueue.main.async {
                    CartManager.shared.clearCart() // Clear existing cart
                    for item in cartResponse.cartItems {
                        let price = Double(item.product.price)
                        CartManager.shared.updateCartItem(
                            productId: item.product.mproduct_id,
                            quantity: item.quantity,
                            price: price
                        )
                    }
                    // Trigger badge update
                    self?.updateCartBadge()
                }
            case .failure(let error):
                print("Error fetching cart items:", error.localizedDescription)
            }
        }
    }

    
    func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.tintColor = .customRed
        tabBar.unselectedItemTintColor = .customBlue
        tabBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let homeVC = DashboardController()
        let shopVC = ShopController()
        let walletVc = WalletViewController()
        let accountVC = AccountController()
        let cartVc = CartController(nibName: "CartController", bundle: nil)
        
        let customFont = UIFont(name: "Roboto-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.customBlue // Color for unselected items
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.customRed // Color for selected item
        ]
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: resizeImage(named: "home", size: CGSize(width: 25, height: 25)), tag: 0)
        shopVC.tabBarItem = UITabBarItem(title: "Browse", image: resizeImage(named: "menub", size: CGSize(width: 25, height: 25)), tag: 1)
        cartVc.tabBarItem = UITabBarItem(title: "Cart", image: resizeImage(named: "cart", size: CGSize(width: 25, height: 25)), tag: 2)
        walletVc.tabBarItem = UITabBarItem(title: "Wallet", image: resizeImage(named: "wallet", size: CGSize(width: 25, height: 25)), tag: 3)
        accountVC.tabBarItem = UITabBarItem(title: "Account", image: resizeImage(named: "user", size: CGSize(width: 25, height: 25)), tag: 4)
        
        // Apply font to all tab bar items
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
        
        viewControllers = [homeVC, shopVC,cartVc, walletVc, accountVC]
    }
    
    func setupAppBar() {
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let window = windowScene.windows.first else { return }
           
           // AppBar View
           appBarView.backgroundColor = .white
           appBarView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(appBarView)
           
           // Overlay View
           overlayView.backgroundColor = UIColor.customBlue
           overlayView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(overlayView)
        
        appBarImageLeadingConstraint = appBarImageView.leadingAnchor.constraint(equalTo: appBarView.leadingAnchor, constant: 16)
        appBarImageCenterConstraint = appBarImageView.centerXAnchor.constraint(equalTo: appBarView.centerXAnchor)

           
           NSLayoutConstraint.activate([
               overlayView.topAnchor.constraint(equalTo: view.topAnchor),
               overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               overlayView.heightAnchor.constraint(equalToConstant: 65) // Height of overlay
           ])
           
           NSLayoutConstraint.activate([
               appBarView.topAnchor.constraint(equalTo: overlayView.bottomAnchor),
               appBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               appBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               appBarView.heightAnchor.constraint(equalToConstant: 60) // Height of app bar
           ])
           
           // ImageView
        appBarImageView.image = UIImage(named: "iconApp")
        appBarImageView.contentMode = .scaleAspectFill
        appBarImageView.translatesAutoresizingMaskIntoConstraints = false
        appBarView.addSubview(appBarImageView)

        appBarImageLeadingConstraint = appBarImageView.leadingAnchor.constraint(equalTo: appBarView.leadingAnchor, constant: 16)
        appBarImageCenterConstraint = appBarImageView.centerXAnchor.constraint(equalTo: appBarView.centerXAnchor)
        appBarImageWidthConstraint = appBarImageView.widthAnchor.constraint(equalToConstant: 40)
        appBarImageHeightConstraint = appBarImageView.heightAnchor.constraint(equalToConstant: 30)

        NSLayoutConstraint.activate([
            appBarImageView.centerYAnchor.constraint(equalTo: appBarView.centerYAnchor),
            appBarImageWidthConstraint,
            appBarImageHeightConstraint,
            appBarImageLeadingConstraint // Start with leading constraint active
        ])
           
           // Label
           appBarLabel.text = "Home"
           appBarLabel.font = UIFont(name: "Roboto-Medium", size: 18)
           appBarLabel.textColor = .customBlue
           appBarLabel.translatesAutoresizingMaskIntoConstraints = false
           appBarView.addSubview(appBarLabel)
           
           NSLayoutConstraint.activate([
            appBarLabel.centerYAnchor.constraint(equalTo: appBarView.centerYAnchor),
               appBarLabel.leadingAnchor.constraint(equalTo: appBarImageView.trailingAnchor, constant: 10)
           ])
           
        cartImageView.image = UIImage(named: "bag")
        cartImageView.tintColor = .customBlue
        cartImageView.contentMode = .scaleAspectFill
        cartImageView.isUserInteractionEnabled = true // Enable interaction
        cartImageView.translatesAutoresizingMaskIntoConstraints = false
        appBarView.addSubview(cartImageView)

        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openCart))
        cartImageView.addGestureRecognizer(tapGesture)

        // Badge Label
        
    //    badgeLabel.text = "0"
        badgeLabel.textColor = .white
      //  badgeLabel.backgroundColor = .customRed
        badgeLabel.textAlignment = .center
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        badgeLabel.layer.cornerRadius = 12 // Half of width/height
        badgeLabel.clipsToBounds = true
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        appBarView.addSubview(badgeLabel)

        // Constraints for cartImageView
        NSLayoutConstraint.activate([
            cartImageView.centerYAnchor.constraint(equalTo: appBarView.centerYAnchor),
            cartImageView.trailingAnchor.constraint(equalTo: appBarView.trailingAnchor, constant: -16),
            cartImageView.widthAnchor.constraint(equalToConstant: 28),
            cartImageView.heightAnchor.constraint(equalToConstant: 28)
        ])

        // Constraints for badgeLabel
        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: cartImageView.topAnchor, constant: -5),
            badgeLabel.trailingAnchor.constraint(equalTo: cartImageView.trailingAnchor, constant: 5),
            badgeLabel.widthAnchor.constraint(equalToConstant: 24),
            badgeLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Balance Label
        balanceLabel.text = "£0.0"
        balanceLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        balanceLabel.textColor = .customBlue
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        appBarView.addSubview(balanceLabel)
        
        NSLayoutConstraint.activate([
            balanceLabel.centerYAnchor.constraint(equalTo: appBarView.centerYAnchor),
            balanceLabel.trailingAnchor.constraint(equalTo: cartImageView.leadingAnchor, constant: -10)
        ])
       }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        updateAppBar(for: item.tag)
    }
    
    @objc func openCart() {
        selectedIndex = 2
            updateAppBar(for: 2)
    }
    
    func updateAppBar(for index: Int) {
        // Default values
        appBarImageWidthConstraint.constant = 40
        appBarImageHeightConstraint.constant = 30
        appBarImageView.contentMode = .scaleAspectFit
        appBarLabel.isHidden = false
        appBarImageLeadingConstraint.isActive = true
        appBarImageCenterConstraint.isActive = false
        appBarImageView.tintColor = .customBlue

        switch index {
        case 0:
            appBarLabel.isHidden = true
            appBarImageLeadingConstraint.isActive = false
            appBarImageCenterConstraint.isActive = true
            appBarImageView.image = UIImage(named: "logo11")
            appBarImageView.contentMode = .scaleToFill
            appBarImageWidthConstraint.constant = 70
            appBarImageHeightConstraint.constant = 50
            toggleShopElements(isVisible: false)

        case 1:
            appBarLabel.text = "Browse"
            appBarImageView.image = UIImage(named: "menub")?.withRenderingMode(.alwaysTemplate)
            toggleShopElements(isVisible: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                   self?.FetchCart()
               }

        case 2:
            appBarLabel.text = "Cart"
            appBarImageView.image = resizeImage(named: "cart", size: CGSize(width: 25, height: 25))
            toggleShopElements(isVisible: false)

        case 3:
            appBarLabel.text = "Wallet"
            appBarImageView.image = resizeImage(named: "wallet", size: CGSize(width: 25, height: 25))
            toggleShopElements(isVisible: false)

        case 4:
            appBarLabel.text = "Account"
            appBarImageView.image = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
            toggleShopElements(isVisible: false)

        default:
            break
        }
    }

    func toggleShopElements(isVisible: Bool) {
        cartImageView.isHidden = !isVisible
        badgeLabel.isHidden = !isVisible
        balanceLabel.isHidden = !isVisible
    }

    // Resizes custom images
    func resizeImage(named imageName: String, size: CGSize) -> UIImage? {
        guard let image = UIImage(named: imageName) else { return nil }
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
