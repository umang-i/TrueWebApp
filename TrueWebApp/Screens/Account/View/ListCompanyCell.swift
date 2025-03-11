//
//  ListCompanyCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ListCompanyCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
           super.awakeFromNib()
        containerView.layer.borderWidth = 1.0  // Adjust thickness as needed
        containerView.layer.borderColor = UIColor.customBlue.cgColor // Custom blue color
        containerView.layer.cornerRadius = 4 // Optional: Add rounded corners for better UI
        containerView.clipsToBounds = true
        addressLabel.font = UIFont(name: "Roboto-Regular", size: 13)!
       }

       override func setSelected(_ selected: Bool, animated: Bool) {
           super.setSelected(selected, animated: animated)
       }

       // Function to configure the cell with an address
       func configure(with address: String) {
           addressLabel.text = address
       }
   }
