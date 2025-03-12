//
//  NotificationCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var notificationTextLabel: UILabel!
    @IBOutlet weak var bellIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationTextLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        arrowImage.tintColor = .customBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
