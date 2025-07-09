//
//  CartCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit

protocol CartCellDelegate: AnyObject {
    func didTapDeleteButton(in cell: CartCell)
    func didUpdateQuantity(in cell: CartCell, quantity: Int)
}

class CartCell: UITableViewCell {
    
    @IBOutlet weak var comparePriceLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var starView: UIView!
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var itemTextLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: CartCellDelegate?
    
    var isFavourite = false {
        didSet {
            updateFavouriteButtonColor()
        }
    }
    
    private var currentCartItem: CartItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        itemTextLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        deleteButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        numberLabel.text = "1"
        contentView.layer.borderColor = UIColor.customBlue.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        
        quantityView.layer.cornerRadius = 4
        quantityView.layer.backgroundColor = UIColor.systemGray5.cgColor
        starView.layer.borderWidth = 1
        starView.layer.borderColor = UIColor.gray.cgColor
        starView.layer.cornerRadius = starView.frame.height / 2
        
        favouriteButton.backgroundColor = .white
        
        updateFavouriteButtonColor()
    }
    
    func setCell(cartItem: CartItem) {
        currentCartItem = cartItem
        itemTextLabel.text = cartItem.product.mproduct_title
        numberLabel.text = "\(cartItem.quantity)"
        isFavourite = cartItem.product.user_info_wishlist
        
        starView.backgroundColor = isFavourite ? .yellow : .systemGray5
        costLabel.text = "£\(String(format: "%.2f", cartItem.product.price))"
        let comparePrice = cartItem.product.compare_price ?? 0.0
        comparePriceLabel.isHidden = (comparePrice <= 0)
        comparePriceLabel.text = "£\(String(format: "%.2f", comparePrice))"
        
        
        if let imageUrl = URL(string: "https://cdn.truewebpro.com/\(cartItem.product.mproduct_image ?? "")") {
            loadImage(from: imageUrl)
        } else {
            itemImageView.image = UIImage(named: "noImage")
        }
        
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        guard let currentNumber = Int(numberLabel.text ?? "1") else { return }
        
        let newQuantity = currentNumber - 1
        
        if newQuantity <= 0 {
            delegate?.didTapDeleteButton(in: self)
        } else {
            numberLabel.text = "\(newQuantity)"
            delegate?.didUpdateQuantity(in: self, quantity: newQuantity)
        }
    }
    
    @IBAction func plusButtonAction(_ sender: Any) {
        guard let currentNumber = Int(numberLabel.text ?? "1") else { return }
        numberLabel.text = "\(currentNumber + 1)"
        delegate?.didUpdateQuantity(in: self, quantity: currentNumber + 1)
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        isFavourite.toggle()
        updateFavouriteButtonColor()
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        delegate?.didTapDeleteButton(in: self)
    }
    
    private func updateFavouriteButtonColor() {
        favouriteButton.tintColor = isFavourite ? .customRed : .gray
        favouriteButton.layer.borderColor = isFavourite ? UIColor.customRed.cgColor : UIColor.gray.cgColor
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.itemImageView.image = UIImage(named: "noImage")
                }
                return
            }
            DispatchQueue.main.async {
                self.itemImageView.image = image
            }
        }.resume()
    }
}
