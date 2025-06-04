//
//  GridCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit
import Lottie

class GridCell: UICollectionViewCell {
    
    var quantityChanged: ((Products, Int) -> Void)?
    var product: Products?
    var saleType : String? = "sale"
    
    // UI Elements
    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false // Prevent font shrinking
        label.minimumScaleFactor = 1.0 // Ensure text wraps instead of shrinking
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saleLottieView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.textColor = .black
        return label
    }()
    
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray  // Optional: Set color
        label.font = UIFont(name: "Roboto-Regular", size: 11)  // Optional: Set font
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 12)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let optionValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 11)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let walletAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .customBlue
        return label
    }()
    
    private let favouriteIcon: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .gray
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.lightGray.cgColor
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customRed
        button.layer.cornerRadius = 15
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.titleEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 0, right: 0)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        
        // Adding elevation effect (shadow)
        view.layer.shadowColor = UIColor.customBlue.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0) // Shadow on all sides
        view.layer.shadowRadius = 6
        view.layer.masksToBounds = false // Allow shadow to extend beyond bounds
        
        return view
    }()
    
    private let bottomPriceLabel: UILabel = {
        let label = UILabel()
        // label.text = "BUY 2 GET 1 FREE"
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Medium", size: 11)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private let offerBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#BB0000", alpha: 0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.preferredMaxLayoutWidth = contentView.bounds.width - 20
    }
    
    private let quantitySelector = QuantitySelectorView()
    
    var isFavourite: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        saleLottieView.play()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = nil
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        // Add shadowView behind contentView
        addSubview(shadowView)
        shadowView.addSubview(contentView)
        
        // Disable autoresizing masks for AutoLayout
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: topAnchor),
            shadowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: shadowView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: shadowView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: shadowView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: shadowView.bottomAnchor)
        ])
        
        // Add subviews
        contentView.addSubview(gridImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(saleLottieView)
        contentView.addSubview(favouriteIcon)
        contentView.addSubview(addButton)
        contentView.addSubview(quantitySelector)
        contentView.addSubview(originalPriceLabel)
        contentView.addSubview(offerBackGroundView)
        contentView.addSubview(optionValueLabel)
        offerBackGroundView.addSubview(bottomPriceLabel)
        // offerBackGroundView.addSubview(bottomTextLabel)
        
        // Enable Auto Layout
        gridImageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        saleLottieView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        originalPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteIcon.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        quantitySelector.translatesAutoresizingMaskIntoConstraints = false
        offerBackGroundView.translatesAutoresizingMaskIntoConstraints = false
        bottomPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        //  bottomTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            saleLottieView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            saleLottieView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            saleLottieView.widthAnchor.constraint(equalToConstant: 50),
            saleLottieView.heightAnchor.constraint(equalToConstant: 50),
            
            // Product Image
            gridImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            gridImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gridImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            gridImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            // Favourite Icon (Star)
            favouriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favouriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favouriteIcon.widthAnchor.constraint(equalToConstant: 30),
            favouriteIcon.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: gridImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            optionValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            optionValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            optionValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
           // optionValueLabel.heightAnchor.constraint(equalToConstant: 17),
            
          //  priceLabel.topAnchor.constraint(equalTo: optionValueLabel.bottomAnchor, constant: 5),
            priceLabel.bottomAnchor.constraint(equalTo: offerBackGroundView.topAnchor, constant: -3),
            priceLabel.centerXAnchor.constraint(equalToSystemSpacingAfter: contentView.centerXAnchor, multiplier: 1),
            priceLabel.heightAnchor.constraint(equalToConstant: 16),
            
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
            originalPriceLabel.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            originalPriceLabel.heightAnchor.constraint(equalToConstant: 17),
            
            offerBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            offerBackGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            offerBackGroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            offerBackGroundView.heightAnchor.constraint(equalToConstant: 20),
            
            bottomPriceLabel.topAnchor.constraint(equalTo: offerBackGroundView.topAnchor, constant: 5),
            bottomPriceLabel.leadingAnchor.constraint(equalTo: offerBackGroundView.leadingAnchor, constant: 5),
            bottomPriceLabel.trailingAnchor.constraint(equalTo: offerBackGroundView.trailingAnchor, constant: -5),
            
            addButton.trailingAnchor.constraint(equalTo: gridImageView.trailingAnchor, constant: 5),
            addButton.bottomAnchor.constraint(equalTo: gridImageView.bottomAnchor, constant: 5),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Quantity Selector (Visible at the bottom)
            quantitySelector.trailingAnchor.constraint(equalTo: gridImageView.trailingAnchor, constant: 5),
            quantitySelector.bottomAnchor.constraint(equalTo: gridImageView.bottomAnchor, constant: 5),
            quantitySelector.widthAnchor.constraint(equalToConstant: 100),
            quantitySelector.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        // Initially hide the quantity selector
        quantitySelector.isHidden = true
        quantitySelector.quantityChanged = { [weak self] count in
                   guard let self = self, let product = self.product else { return }
                   self.quantityChanged?(product, count)
               }
        
        // Button Actions
        favouriteIcon.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func configure(item: Products, cartItems: [CartItem]) {
        nameLabel.text = item.brand_name
        titleLabel.text = item.mproduct_title
        priceLabel.text = "£\(item.price)"
        walletAmountLabel.text = "£\(item.sku)"
        self.isFavourite = item.user_info_wishlist == true ? true : false
        self.product = item
        
        favouriteIcon.tintColor = item.user_info_wishlist == true  ? .customRed : .gray
        favouriteIcon.setImage(
            UIImage(systemName: item.user_info_wishlist == true  ? "heart.fill" : "heart"),
            for: .normal
        )
        favouriteIcon.layer.borderColor = (item.user_info_wishlist == true  ? UIColor.customRed : UIColor.gray).cgColor
        
        titleLabel.textColor = .black
        priceLabel.textColor = .black
        optionValueLabel.textColor = .black
        nameLabel.textColor = .black
        
        if item.cost_price == 0 {
            originalPriceLabel.isHidden = true
        }else {
            originalPriceLabel.text = "£\(item.cost_price ?? 0.0)"
        }
        
        
        if let optionValues = item.option_value, !optionValues.isEmpty {
            let valuesText = optionValues.values.joined(separator: ", ")
            optionValueLabel.text = valuesText
        } else {
            optionValueLabel.text = nil // or "" if you prefer it empty
        }
        
        // Check if the product is in cart and set quantity
        if let cartItem = cartItems.first(where: { $0.product.mvariant_id == item.mvariant_id }) {
               quantitySelector.isHidden = false
               addButton.isHidden = true
               quantitySelector.count = cartItem.quantity
           } else {
               quantitySelector.isHidden = true
               addButton.isHidden = false
               quantitySelector.count = 0
           }
        
        if let cartItem = cartItems.first(where: { $0.product.mvariant_id == item.mvariant_id }) {
               quantitySelector.isHidden = false
               addButton.isHidden = true
               quantitySelector.count = cartItem.quantity
           } else {
               quantitySelector.isHidden = true
               addButton.isHidden = false
           }

           // Add this to handle quantity changes:
        quantitySelector.quantityChanged = { [weak self] newCount in
               guard let self = self, let product = self.product else { return }
               print("Quantity changed for variant ID: \(product.mvariant_id), new count: \(newCount)")
               
               if newCount > 0 {
                   CartManager.shared.updateCartItem(mVariantId: product.mvariant_id, quantity: newCount, price: product.price)
                   self.saveCartItem(mvariantId: product.mvariant_id, quantity: newCount, unitPrice: product.price)
               } else {
                   CartManager.shared.updateCartItem(mVariantId: product.mvariant_id, quantity: 0, price: 0)
                   self.quantitySelector.isHidden = true
                   self.addButton.isHidden = false
               }
           }
        
        // Configure Offer Label
        if let offersLabel = item.product_offer, !offersLabel.isEmpty {
            bottomPriceLabel.text = offersLabel.capitalized
            offerBackGroundView.backgroundColor = UIColor(hex: "#BB0000", alpha: 0.2)
            offerBackGroundView.isHidden = false
        }else if cartItems.first(where: { $0.product.mvariant_id == item.mvariant_id })?.quantity == 0  {
            bottomPriceLabel.text = "Out of Stock"
            titleLabel.textColor = .lightGray
            priceLabel.textColor = .lightGray
            optionValueLabel.textColor = .lightGray
            nameLabel.textColor = .lightGray
            quantitySelector.isHidden = true
            addButton.isHidden = true
            offerBackGroundView.backgroundColor = UIColor(hex: "#BB0000", alpha: 0.2)
            offerBackGroundView.isHidden = false
        }  else {
            bottomPriceLabel.text = ""
            offerBackGroundView.isHidden = true
            titleLabel.textColor = .black
            priceLabel.textColor = .black
            optionValueLabel.textColor = .black
            nameLabel.textColor = .black
        }
        
        // Configure Lottie Animation for Sale/Flash Deal
        if let sale = item.product_deal_tag, !sale.isEmpty {
            saleType = sale == "Sale" ? "sale" : "flash_deals"
            saleLottieView.animation = LottieAnimation.named(saleType ?? "sale")
            saleLottieView.isHidden = false
            saleLottieView.play()
        } else {
            saleLottieView.isHidden = true
            saleLottieView.stop()
        }
        
        // Wishlist UI Configuration
        updateFavouriteUI()
        
        // Load Image
        let imageUrlString = "https://cdn.truewebpro.com/\(item.mproduct_image ?? "https://cdn.truewebpro.com/goapp/images/mbrands/mbrand_681a021e19710.png")"
        if let url = URL(string: imageUrlString) {
            gridImageView.load(url: url)
        } else {
            gridImageView.image = UIImage(named: "noImage") // Default placeholder
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        quantitySelector.quantityChanged = nil
        product = nil
        quantitySelector.count = 0
        quantitySelector.isHidden = true
        addButton.isHidden = false
    }

    @objc private func favouriteButtonTapped() {
        isFavourite.toggle()
        updateFavouriteUI()
        handleFavouriteAPI()
    }
    
    /// Updates the UI based on the isFavourite state
    private func updateFavouriteUI() {
        favouriteIcon.tintColor = isFavourite ? .customRed : .gray
        favouriteIcon.setImage(
            UIImage(systemName: isFavourite ? "heart.fill" : "heart"),
            for: .normal
        )
        favouriteIcon.layer.borderColor = (isFavourite ? UIColor.customRed : UIColor.gray).cgColor
        
    }
    
    /// Handles the wishlist API using the service
    private func handleFavouriteAPI() {
        guard let product = product else {
            print("Error: Product is nil in handleFavouriteAPI.")
            return
        }
        
        guard let userId = UserDefaults.standard.string(forKey: "userId"), !userId.isEmpty else {
            print("Error: User ID is missing.")
            return
        }
        
        let productId = "\(product.mvariant_id)"
        print("Handling Favourite API - UserID: \(userId), VariantId: \(productId), IsFavourite: \(isFavourite)")
        
        let apiService = ApiService()
        
        apiService.makeWishlistRequest(userId: userId, productId: productId , mVarientId: "\(product.mvariant_id)") { [weak self] success, error in
            guard let self = self else { return }
            if !success {
                DispatchQueue.main.async {
                    self.isFavourite.toggle()
                    self.updateFavouriteUI()
                    print("Error adding to wishlist:", error ?? "Unknown error")
                }
            }
        }
    }
    
    @objc private func addButtonTapped() {
        addButton.isHidden = true  // Hide the '+' button
        quantitySelector.isHidden = false  // Show the quantity selector
        quantitySelector.count = 1
        
        guard let product = product else { return }
        
        // Set product ID and price for QuantitySelector
        quantitySelector.mvariantId = product.mvariant_id
        quantitySelector.unitPrice = product.price
        print(product.price)
        
        // Add product to cart with initial quantity
        CartManager.shared.updateCartItem(mVariantId: product.mvariant_id, quantity: 1, price: product.price)
        saveCartItem(mvariantId: product.mvariant_id, quantity: 1, unitPrice: product.price) // Save locally
        
        // Handle quantity changes dynamically
        quantitySelector.quantityChanged = { [weak self] count in
            guard let self = self else { return }
            guard let product = self.product else { return }
            
            if count > 0 {
                // Update cart with the new quantity
                print(product.price)
                CartManager.shared.updateCartItem(mVariantId: product.mvariant_id, quantity: count, price: product.price)
                self.saveCartItem(mvariantId: product.mvariant_id, quantity: count, unitPrice: product.price) // Save locally
            } else {
                print(product.price)
                // Remove item from cart and show add button
                CartManager.shared.updateCartItem(mVariantId: product.mvariant_id, quantity: 0, price: 0)
                self.quantitySelector.isHidden = true
                self.addButton.isHidden = false
            }
        }
    }
}


class QuantitySelectorView: UIView {
    
 //   var productId: Int!
    var mvariantId : Int!
    var unitPrice: Double = 0.0
    
    var count: Int = 1 {
        didSet {
            countLabel.text = "\(count)"
            animateSizeChange()
            updateCart()
            quantityChanged?(count)
        }
    }
    
    var quantityChanged: ((Int) -> Void)?
    
    private func setupActions() {
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    
    // MARK: - Cart Update
    private func updateCart() {
        guard let mvariantId = mvariantId else { return }
        
        // Calculate total price based on unit price * quantity
        let totalPrice = Double(count) * unitPrice
        
        // Update CartManager with unit price, but calculate total dynamically
        CartManager.shared.updateCartItem(mVariantId: mvariantId, quantity: count, price: unitPrice)
        
    }

    // MARK: - Actions
    @objc private func minusTapped() {
        if count > 0 {
            count -= 1
        }
        if count == 0 {
            self.isHidden = true
        }
    }

    @objc private func plusTapped() {
        count += 1
        self.isHidden = false
    }

    // MARK: - UI Elements
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("−", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
        label.font = UIFont(name: "Roboto-Regular", size: 20)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = UIColor.customRed
        layer.cornerRadius = 4
        clipsToBounds = true
        
        addSubview(minusButton)
        addSubview(countLabel)
        addSubview(plusButton)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Animation
    private func animateSizeChange() {
        UIView.animate(withDuration: 0.2) {
            self.transform = self.count == 0 ? CGAffineTransform(scaleX: 0.1, y: 0.1) : .identity
            self.alpha = self.count == 0 ? 0 : 1
        }
    }
}


import UIKit
class BannerImageCelll: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
