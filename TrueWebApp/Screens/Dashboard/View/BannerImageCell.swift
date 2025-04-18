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
        bannerImageView.layer.cornerRadius = 10
        bannerImageView.clipsToBounds = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        bannerImageView.layer.cornerRadius = 10
        bannerImageView.clipsToBounds = true
    }

    
    func setImages(imgName : String , callerId : Int){
        bannerImageView.image = UIImage(named: imgName)
        
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          bannerImageView.image = nil // Prevents incorrect image reuse
      }

}
