//
//  CartCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit

protocol CartCellDelegate: AnyObject {
   // func didTapFavouriteButton(in cell: CartCell)
    func didTapDeleteButton(in cell: CartCell)
}

class CartCell: UITableViewCell {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemTextLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        deleteButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 15)
        numberLabel.text = "1"
        contentView.layer.borderColor = UIColor.customBlue.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 4
        
        quantityView.layer.cornerRadius = 4
        quantityView.layer.borderWidth = 1
        quantityView.layer.borderColor = UIColor.customBlue.cgColor
        starView.layer.borderWidth = 1
        starView.layer.borderColor = UIColor.gray.cgColor
        starView.layer.cornerRadius = starView.frame.height / 2
        
        updateFavouriteButtonColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        if let currentNumber = Int(numberLabel.text ?? "1"), currentNumber > 1 {
            numberLabel.text = "\(currentNumber - 1)"
        }
    }
    @IBAction func plusButtonAction(_ sender: Any) {
        if let currentNumber = Int(numberLabel.text ?? "1") {
            numberLabel.text = "\(currentNumber + 1)"
        }
    }
    @IBAction func favouriteButtonAction(_ sender: Any) {
        isFavourite.toggle()
    }
    @IBAction func deleteButtonAction(_ sender: Any) {
        delegate?.didTapDeleteButton(in: self)
    }
    
    private func updateFavouriteButtonColor() {
        favouriteButton.tintColor = isFavourite ? .customRed : .gray
    }
}
