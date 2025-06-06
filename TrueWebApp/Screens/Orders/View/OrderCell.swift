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
    
    var orders : Order?
    weak var delegate: OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyCustomFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func reorderButtonAction(_ sender: Any) {
        let items = orders?.items.map {
            OrderItem(mvariant_id: $0.mvariantId, quantity: $0.quantity, unit_price: $0.unitPrice)
        } ?? []

        let orderRequest = OrderRequest(
            items: items,
            user_company_address_id: orders?.delivery.address_id ?? 0,
            delivery_method_id: orders?.delivery.method_id ?? 0,
            coupon_discount: orders?.summary.couponDiscount ?? 0.0,
            wallet_discount: orders?.summary.walletDiscount ?? 0.0
        )
        
        ApiService.shared.submitOrder(order: orderRequest) { result in
            switch result {
            case .success(let response):
                print("Order placed: \(response)")
                DispatchQueue.main.async {
                    self.delegate?.didTapReorderButton(on: self)
                }
            case .failure(let error):
                print("Error placing order: \(error.localizedDescription)")
            }
        }
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
        self.orders = order
        // Order number
        orderNumber.text = "#\(order.orderId)"
        orderedOnLabel.text = order.orderDate
        
        // Payment and Fulfillment status
        paymentStatus.text = order.paymentStatus.capitalized
        fulfilmentStatusLabel.text = order.fulfillmentStatus

        skuNumLabel.text = "\(order.skus)"
        unitsNumberLabel.text = "\(order.units)"

        // Total paid
        totalPaidNum.text = "£\(order.summary.paymentTotal)"
    }
}


protocol OrderCellDelegate: AnyObject {
    func didTapReorderButton(on cell: OrderCell)
}
