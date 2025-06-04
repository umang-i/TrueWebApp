//
//  OrderCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class OrderCell: UITableViewCell {

    @IBOutlet weak var reorderButton: UIButton!
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
    
    @IBAction func reorderButtonAction(_ sender: Any) {
     
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
    
    func setCell(order: Order) {
        // Order number
        orderNumber.text = "#\(order.orderId)"
        
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = inputFormatter.date(from: order.createdAt) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd-MM-yyyy 'at' h:mm a"
            orderedOnLabel.text = outputFormatter.string(from: date)
        } else {
            orderedOnLabel.text = order.createdAt
        }
        
        // Payment and Fulfillment status
        paymentStatus.text = order.status.capitalized // Assuming status means payment here
        fulfilmentStatusLabel.text = "Pending" // You can change this based on your API

        // SKU count (unique mvariant_id count)
        let uniqueSKUs = Set(order.items.map { $0.mvariantId })
        skuNumLabel.text = "\(uniqueSKUs.count)"

        // Units (sum of quantities)
        let totalUnits = order.items.reduce(0) { $0 + $1.quantity }
        unitsNumberLabel.text = "\(totalUnits)"

        // Total paid
        totalPaidNum.text = "£\(order.totalAmount)"

        // Optional: If you want to show user name
       // orderedNameLabel.text = order.user.name
    }
}
