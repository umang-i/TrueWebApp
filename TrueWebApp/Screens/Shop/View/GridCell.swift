//
//  GridCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit
import Lottie

class GridCell: UICollectionViewCell {
    
    var quantityChanged: ((Product, Int) -> Void)?
    var product: Product?
    
    // UI Elements
    private let gridImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
//    private let saleLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont(name: "Roboto-Medium", size: 14)
//        label.numberOfLines = 2
//        label.text = "SALE"
//        label.textColor = .customRed
//        label.textAlignment = .left
//        return label
//    }()
    private let saleLottieView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "sale")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.textColor = .black
        return label
    }()
    
    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an attributed string with a strikethrough
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: "£3.50")
        attributeString.addAttribute(.strikethroughStyle,
                                     value: NSUnderlineStyle.single.rawValue,
                                     range: NSRange(location: 0, length: attributeString.length))
        
        label.attributedText = attributeString
        label.textColor = .gray  // Optional: Set color
        label.font = UIFont(name: "Roboto-Regular", size: 11)  // Optional: Set font
        return label
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 13)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let walletAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
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
        label.text = "BUY 2 GET 1 FREE"
        label.textColor = .black
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
//    private let bottomTextLabel: UILabel = {
//        let label = UILabel()
//        label.text = "FAM members"
//        label.textColor = .black
//        label.font = UIFont(name: "Roboto-Bold", size: 12)
//        label.numberOfLines = 2
//        label.textAlignment = .left
//        return label
//    }()

    private let offerBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#BB0000", alpha: 0.2)
        view.layer.cornerRadius = 4
        return view
    }()
    
    
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
            saleLottieView.widthAnchor.constraint(equalToConstant: 60),
            saleLottieView.heightAnchor.constraint(equalToConstant: 50),
            
            // Product Image
            gridImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            gridImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            gridImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            gridImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),
            
            // Favourite Icon (Star)
            favouriteIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            favouriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favouriteIcon.widthAnchor.constraint(equalToConstant: 30),
            favouriteIcon.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.topAnchor.constraint(equalTo: gridImageView.bottomAnchor, constant: 10),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            // Price Label (Discounted & Original Price)
            priceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor , constant: -10),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            
            originalPriceLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 5),
            originalPriceLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor, constant: 0),
            
            offerBackGroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            offerBackGroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            offerBackGroundView.topAnchor.constraint(equalTo: originalPriceLabel.bottomAnchor, constant: 10),
            offerBackGroundView.heightAnchor.constraint(equalToConstant: 25),
            
            bottomPriceLabel.topAnchor.constraint(equalTo: offerBackGroundView.topAnchor, constant: 5),
            bottomPriceLabel.leadingAnchor.constraint(equalTo: offerBackGroundView.leadingAnchor, constant: 5),
            bottomPriceLabel.trailingAnchor.constraint(equalTo: offerBackGroundView.trailingAnchor, constant: -5),
            
            // Bottom Text Label (Below Bottom Price Label)
//            bottomTextLabel.topAnchor.constraint(equalTo: bottomPriceLabel.bottomAnchor, constant: 2),
//            bottomTextLabel.leadingAnchor.constraint(equalTo: offerBackGroundView.leadingAnchor, constant: 5),
//            bottomTextLabel.trailingAnchor.constraint(equalTo: offerBackGroundView.trailingAnchor, constant: -5),
//            bottomTextLabel.bottomAnchor.constraint(equalTo: offerBackGroundView.bottomAnchor, constant: -5),
//            
            
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

        // Button Actions
        favouriteIcon.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    func configure(title: String, image: String, price: String, wallet: String, brand: String) {
        nameLabel.text = brand
        titleLabel.text = title
        priceLabel.text = "£\(price)"
        walletAmountLabel.text = "£\(wallet)"
        
        // Load image from URL
        if let url = URL(string: image) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let loadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.gridImageView.image = loadedImage
                    }
                }
            }
        } else {
            // Set a default placeholder image
            gridImageView.image = UIImage(named: "lays")
        }
    }
    
    @objc private func favouriteButtonTapped() {
        isFavourite.toggle()
        favouriteIcon.tintColor = isFavourite ? .customRed : .gray
        favouriteIcon.setImage(
            UIImage(systemName: isFavourite ? "heart.fill" : "heart"),
            for: .normal
        )
        favouriteIcon.layer.borderColor = (isFavourite ? UIColor.customRed : UIColor.gray).cgColor
    }
    
    @objc private func addButtonTapped() {
        addButton.isHidden = true  // Hide the '+' button
        quantitySelector.isHidden = false  // Show the quantity selector
        quantitySelector.count = 1
        quantityChanged?(product!, 1)
        
        // Handle quantity changes
        quantitySelector.quantityChanged = { [weak self] count in
            guard let self = self else { return }
            
            if count == 0 {
                self.quantitySelector.isHidden = true
                self.addButton.isHidden = false  // Show the add button again
            }
        }
    }
}


import UIKit

class QuantitySelectorView: UIView {
    
    var count: Int = 1 {
            didSet {
                countLabel.text = "\(count)"
                animateSizeChange()
                quantityChanged?(count)
            }
        }
    var quantityChanged: ((Int) -> Void)?
    
    private func setupActions() {
           minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
           plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
       }
    @objc private func minusTapped() {
        if count > 0 {
            count -= 1
            quantityChanged?(count)
        }
        
        if count == 0 {
            self.isHidden = true
        }
    }

       @objc private func plusTapped() {
           count += 1
           quantityChanged?(count)
       }

    // UI Elements
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
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor.customRed
        layer.cornerRadius = 4
        //layer.borderWidth = 1
       // layer.backgroundColor = UIColor.customRed.cgColor
        clipsToBounds = true
        
        addSubview(minusButton)
        addSubview(countLabel)
        addSubview(plusButton)
        
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Count Label
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            // Minus Button
            minusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            minusButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            // Plus Button
            plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            plusButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc private func increaseCount() {
        count += 1
    }
    
    @objc private func decreaseCount() {
        if count > 0 {
            count -= 1
        }
    }

    private func animateSizeChange() {
        UIView.animate(withDuration: 0.2) {
            if self.count == 0 {
                self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                self.alpha = 0
            } else {
                self.transform = .identity
                self.alpha = 1
            }
        }
    }
}

