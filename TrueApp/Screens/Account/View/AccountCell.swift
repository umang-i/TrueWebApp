//
//  AccountCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textLabelView: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
    private func setupUI() {
        iconImageView.tintColor = UIColor.customBlue // Set icon color
        textLabelView.textColor = .black
        textLabelView.font = UIFont(name: "Roboto-Medium", size: 16)!

    }

    func configure(with item: AccountItem) {
        iconImageView.image = UIImage(systemName: item.iconName)
        textLabelView.text = item.title
    }
}
