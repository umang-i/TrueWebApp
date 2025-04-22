//
//  BrandCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 11/03/25.
//

import UIKit

class BrandCell: UICollectionViewCell {

    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    
    override func awakeFromNib() {
           super.awakeFromNib()
           setupCellAppearance()
           setupGestureRecognizers()
       }
       
       private func setupCellAppearance() {
           brandView.layer.cornerRadius = 10
           brandView.isUserInteractionEnabled = false // Allow touches to pass through
           
           // Image view styling
           brandImageView.backgroundColor = .yellow
           brandImageView.layer.cornerRadius = 10
           brandImageView.clipsToBounds = true
           
           // Checkmark styling
           checkmarkImageView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
           checkmarkImageView.tintColor = .systemGreen
           checkmarkImageView.isHidden = true
       }
       
       private func setupGestureRecognizers() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
           tapGesture.cancelsTouchesInView = false
           contentView.addGestureRecognizer(tapGesture)
       }
       
       func setSelectedState(isSelected: Bool) {
           checkmarkImageView.isHidden = !isSelected 
       }
       
       func setImage(img: String) {
           brandImageView.image = UIImage(named: img)
       }
       
       @objc private func cellTapped() {
           // Handle cell tap if needed
       }
       
       override var isSelected: Bool {
           didSet {
               setSelectedState(isSelected: isSelected)
           }
       }
   }
