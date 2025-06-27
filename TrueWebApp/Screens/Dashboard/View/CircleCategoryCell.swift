//
//  CircleCategoryCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 21/03/25.
//

import UIKit

class CircleCategoryCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var circleImageHeight: NSLayoutConstraint!
    @IBOutlet weak var circleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 33
        circleImageView.layer.cornerRadius = 33
        circleImageView.contentMode = .scaleAspectFill
    }
    
    func setCell(categoryName : String , image : String){
        if let url = URL(string: "https://cdn.truewebpro.com/\(image)") {
            circleImageView.sd_setImage(with: url , placeholderImage:  UIImage(named: "noImage"))
        }
    }
}
