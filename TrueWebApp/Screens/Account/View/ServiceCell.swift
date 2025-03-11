//
//  ServiceCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ServiceCell: UITableViewCell {

    @IBOutlet weak var serviceContainerView: UIView!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var serviceImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        serviceContainerView.layer.borderWidth = 1.0  // Adjust thickness as needed
        serviceContainerView.layer.borderColor = UIColor.customBlue.cgColor // Custom blue color
        serviceContainerView.layer.cornerRadius = 4 // Optional: Add rounded corners for better UI
        serviceContainerView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
