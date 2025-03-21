//
//  bannerImageCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 18/03/25.
//

import UIKit

class BannerImageCell: UICollectionViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    func setImages(imgName : String , callerId : Int){
        bannerImageView.image = UIImage(named: imgName)
        bannerImageView.layer.cornerRadius = 10
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          bannerImageView.image = nil // Prevents incorrect image reuse
      }

}
