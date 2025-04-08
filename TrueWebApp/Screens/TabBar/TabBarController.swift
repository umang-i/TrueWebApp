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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupTabBar()
        setupAppBar()
        updateAppBar(for: selectedIndex)
    }
    
    func setupTabBar() {
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.tintColor = .customRed
        tabBar.unselectedItemTintColor = .customBlue
        tabBar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let homeVC = DashboardController()
        let shopVC = ShopViewController()
        let walletVc = WalletViewController()
       // let rewardVc = RewardsController(nibName: "RewardsController", bundle: nil)
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
          // appBarView.layer.shadowColor = UIColor.black.cgColor
           //appBarView.layer.shadowOpacity = 0.2
           //appBarView.layer.shadowOffset = CGSize(width: 0, height: 2)
          // appBarView.layer.shadowRadius = 3
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
        
        badgeLabel.text = "5"  // Dynamic number
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .customRed
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
        balanceLabel.text = "£200.50"
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
        switch index {
        case 0:
            appBarLabel.isHidden = true

            appBarImageLeadingConstraint.isActive = false
            appBarImageCenterConstraint.isActive = true

            appBarImageView.image = UIImage(named: "logo11")
            appBarImageView.contentMode = .scaleToFill

            // Update image size to 60x60
            appBarImageWidthConstraint.constant = 70
            appBarImageHeightConstraint.constant = 50

            toggleShopElements(isVisible: false)

        case 1:
            appBarLabel.text = "Browse"
            appBarLabel.isHidden = false

            appBarImageView.image = UIImage(named: "menub")?.withRenderingMode(.alwaysTemplate)
            appBarImageView.contentMode = .scaleAspectFit
            appBarImageView.tintColor = .customBlue

            appBarImageLeadingConstraint.isActive = true
            appBarImageCenterConstraint.isActive = false
            
            appBarImageWidthConstraint.constant = 40
            appBarImageHeightConstraint.constant = 30

            toggleShopElements(isVisible: true)

        case 2:
            appBarLabel.text = "Cart"
            appBarLabel.isHidden = false

            appBarImageView.image = resizeImage(named: "cart", size: CGSize(width: 25, height: 25))
            appBarImageView.tintColor = .customBlue

            appBarImageLeadingConstraint.isActive = true
            appBarImageCenterConstraint.isActive = false
            
            appBarImageWidthConstraint.constant = 40
            appBarImageHeightConstraint.constant = 30

            toggleShopElements(isVisible: false)

        case 3:
            appBarLabel.text = "Wallet"
            appBarLabel.isHidden = false

            appBarImageView.image = resizeImage(named: "wallet", size: CGSize(width: 25, height: 25))
            appBarImageView.tintColor = .customBlue

            appBarImageLeadingConstraint.isActive = true
            appBarImageCenterConstraint.isActive = false
            
            appBarImageWidthConstraint.constant = 40
            appBarImageHeightConstraint.constant = 30

            toggleShopElements(isVisible: false)

        case 4:
            appBarLabel.text = "Account"
            appBarLabel.isHidden = false

            appBarImageView.image = UIImage(named: "user")?.withRenderingMode(.alwaysTemplate)
            appBarImageView.tintColor = .customBlue

            appBarImageLeadingConstraint.isActive = true
            appBarImageCenterConstraint.isActive = false
            
            appBarImageWidthConstraint.constant = 40
            appBarImageHeightConstraint.constant = 30

            toggleShopElements(isVisible: false)

        default:
            appBarImageWidthConstraint.constant = 40
            appBarImageHeightConstraint.constant = 30
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
