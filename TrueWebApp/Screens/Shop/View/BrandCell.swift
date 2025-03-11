//
//  BrandCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 11/03/25.
//

import UIKit

class BrandCell: UICollectionViewCell {

    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        brandImageView.image = UIImage(named: "brand")
        brandView.layer.cornerRadius = 4
        brandImageView.layer.cornerRadius = 4
        brandView.layer.borderColor = UIColor.customBlue.cgColor
        brandView.layer.borderWidth = 1.5
    }
      
    func setSelectedState(isSelected: Bool) {
           brandView.layer.borderColor = isSelected ? UIColor.customRed.cgColor : UIColor.customBlue.cgColor
       }
}
