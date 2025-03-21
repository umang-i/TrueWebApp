//
//  CircleCategoryCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 21/03/25.
//

import UIKit

class CircleCategoryCell: UICollectionViewCell {

    @IBOutlet weak var circleImageHeight: NSLayoutConstraint!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var circleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        circleImageView.layer.cornerRadius = 33
        circleImageView.contentMode = .scaleAspectFill
    }
    
    func setCell(categoryName : String , image : String){
        circleImageView.image = UIImage(named: image)
        catLabel.text = categoryName
    }
}
