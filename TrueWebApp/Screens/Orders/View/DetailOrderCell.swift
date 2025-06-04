//
//  DetailOrderCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class DetailOrderCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var orderTextLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderTextLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        quantityLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        priceLabel.font = UIFont(name: "Roboto-Bold", size: 13)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(order : OrderItems){
        priceLabel.text = "£\(order.unitPrice)"
        quantityLabel.text = "\(order.quantity)"
    }
}
