//
//  bannerImageCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 18/03/25.
//

import UIKit
import SDWebImage

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

    
    func setImages(imgName: String, callerId: Int) {
        guard let url = URL(string: "https://cdn.truewebpro.com/\(imgName)") else {
            bannerImageView.image = UIImage(named: "noImage")
            return
        }

        // Add shimmer
        let shimmerTag = 1010
        var shimmerView = bannerImageView.viewWithTag(shimmerTag) as? ShimmerView
        if shimmerView == nil {
            shimmerView = ShimmerView(frame: bannerImageView.bounds)
            shimmerView?.tag = shimmerTag
            shimmerView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bannerImageView.addSubview(shimmerView!)
        }
        shimmerView?.startAnimating()

        // Load image
        bannerImageView.sd_setImage(with: url, placeholderImage: nil, options: [], completed: { [weak shimmerView] _, _, _, _ in
            shimmerView?.stopAnimating()
            shimmerView?.removeFromSuperview()
        })
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
          bannerImageView.image = nil // Prevents incorrect image reuse
      }
}
