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
        // Initialization code
    }
    
    func setImages(imgName : String){
        bannerImageView.image = UIImage(named: imgName)
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          bannerImageView.image = nil // Prevents incorrect image reuse
      }

}
