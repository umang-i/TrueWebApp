//
//  OrderCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var totalPaidNum: UILabel!
    @IBOutlet weak var totalPaidLabel: UILabel!
    @IBOutlet weak var skuNumLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var unitsNumberLabel: UILabel!
    @IBOutlet weak var unitsNameLabel: UILabel!
    @IBOutlet weak var fulfilmentStatusLabel: UILabel!
    @IBOutlet weak var fulfilmentlabel: UILabel!
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var paymentStatusLabel: UILabel!
    @IBOutlet weak var orderedOnLabel: UILabel!
    @IBOutlet weak var orderedNameLabel: UILabel!
    @IBOutlet weak var orderNumber: UILabel!
    @IBOutlet weak var orderNumberLable: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCustomFont()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func applyCustomFont() {
            let fontName = "Roboto-Regular"
            let fontSize: CGFloat = 12 // Adjust size as needed

            let labels = [
                totalPaidNum, totalPaidLabel, skuNumLabel, skuLabel,
                unitsNumberLabel, unitsNameLabel, fulfilmentStatusLabel, fulfilmentlabel,
                paymentStatus, paymentStatusLabel, orderedOnLabel, orderedNameLabel,
                orderNumber, orderNumberLable
            ]

            for label in labels {
                label?.font = UIFont(name: fontName, size: fontSize)
                label?.textColor = .black
            }
        }
    
}
