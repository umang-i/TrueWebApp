//
//  DetailOrderController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class DetailOrderController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var orderLinesLabel: UILabel!
    @IBOutlet weak var ordersummaryLabel: UILabel!
    @IBOutlet weak var couponDiscTextLabel: UILabel!
    @IBOutlet weak var couponDiscLabel: UILabel!
    @IBOutlet weak var paymentTotalPriceLabel: UILabel!
    @IBOutlet weak var vatPriceLable: UILabel!
    @IBOutlet weak var deliveryPriceLabel: UILabel!
    @IBOutlet weak var walletDiscNumLabel: UILabel!
    @IBOutlet weak var subtotalNumLabel: UILabel!
    @IBOutlet weak var paymentTotalLabel: UILabel!
    @IBOutlet weak var vatTextLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var deliveryPriceTextLabel: UILabel!
    @IBOutlet weak var walletDiscountLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var addressTextLable: UILabel!
    @IBOutlet weak var skuNumberLabel: UILabel!
    @IBOutlet weak var skulabel: UILabel!
    @IBOutlet weak var unitquantityLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var cancelOrderButton: UIButton!
    @IBOutlet weak var completePaymentButton: UIButton!
    @IBOutlet weak var orderBackgroundView: UIView!
    @IBOutlet weak var orderListTableView: UITableView!
    
    var isPaid: Bool!
    var orderId : Int!
    var order: Order?
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        orderListTableView.delegate = self
        orderListTableView.dataSource = self
        orderListTableView.register(UINib(nibName: "DetailOrderCell", bundle: nil), forCellReuseIdentifier: "DetailOrderCell")
        orderBackgroundView.layer.borderWidth = 0.5
        orderBackgroundView.layer.borderColor = UIColor.customBlue.cgColor
        orderBackgroundView.layer.cornerRadius = 4
        setnavBar()
        updateUIForPaymentStatus()
        setUI()
        fetchOrder()
        
    }
    
    func setUI(){
        orderDetailLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        unitLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        skulabel.font = UIFont(name: "Roboto-Regular", size: 13)
        deliveryLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        summaryLabel.font = UIFont(name: "Roboto-Medium", size: 13)
        subtotalLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        walletDiscountLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        deliveryPriceLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        vatLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        paymentTotalLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        unitquantityLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        skuNumberLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        addressTextLable.font = UIFont(name: "Roboto-Regular", size: 13)
        deliveryPriceTextLabel.font = UIFont(name: "Roboto-Regular", size: 13)
        subtotalNumLabel.font = UIFont(name: "Roboto-Regular", size: 13);
        walletDiscNumLabel.font = UIFont(name: "Roboto-Regular", size: 13);
        couponDiscLabel.font = UIFont(name: "Roboto-Regular", size: 13);
        couponDiscTextLabel.font = UIFont(name: "Roboto-Regular", size: 13);
        ordersummaryLabel.font = UIFont(name: "Roboto-Medium", size: 18);
        orderLinesLabel.font = UIFont(name: "Roboto-Medium", size: 18);
        completePaymentButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16);
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Order Detail")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            // Background View Constraints (covers top of the screen)
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed

            // CustomNavBar Constraints
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func updateTableViewHeight() {
        let cellHeight: CGFloat = 80
        let footerHeight: CGFloat = 10
        let totalHeight = CGFloat(order?.items.count ?? 0) * (cellHeight + footerHeight)
        tableviewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }
    
    func updateUIForPaymentStatus() {
            if isPaid {
                cancelOrderButton.isHidden = true
                completePaymentButton.backgroundColor = UIColor.customBlue // Replace with your custom blue color
                completePaymentButton.setTitle("Reorder Items", for: .normal)
                completePaymentButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
                // Increase button height (if using Auto Layout)
                if let heightConstraint = (completePaymentButton.constraints.filter { $0.firstAttribute == .height }.first) {
                    heightConstraint.constant = 55 // Adjust height as needed
                }
                completePaymentButton.layer.cornerRadius = 4


            } else {
                cancelOrderButton.isHidden = false
                completePaymentButton.backgroundColor = .systemBlue // Or your default color
                completePaymentButton.setTitle("Complete Payment", for: .normal)
                completePaymentButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
                // Reset height if you changed it
                if let heightConstraint = (completePaymentButton.constraints.filter { $0.firstAttribute == .height }.first) {
                    heightConstraint.constant = 44 // Or your default height
                }
            }
            completePaymentButton.layoutIfNeeded() //update layout
        }
    
    func fetchOrder() {
        guard let orderId = orderId else { return }

        ApiService.shared.fetchSingleOrder(orderId: "\(orderId)") { result in
            switch result {
            case .success(let order):
                DispatchQueue.main.async {
                    self.order = order
                    self.unitquantityLabel.text = "\(order.units)"
                    self.skuNumberLabel.text = "\(order.skus)"
                    self.subtotalNumLabel.text = "£\(order.summary.subtotal)"
                    self.walletDiscNumLabel.text = "- £\(order.summary.walletDiscount)"
                    self.couponDiscTextLabel.text = "- £\(order.summary.couponDiscount)"
                    self.deliveryPriceTextLabel.text = "£\(order.summary.deliveryCost)"
                    self.vatTextLabel.text = " £\(order.summary.vat)"
                    self.paymentTotalPriceLabel.text = "£\(order.summary.paymentTotal)"
                    self.addressTextLable.text = "\(order.delivery.method)\n\(order.delivery.address)"
                    self.orderListTableView.reloadData()
                }
            case .failure(let error):
                print("❌ Error fetching order: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func completePaymentButtonAction(_ sender: Any) {
        guard let orderId = orderId else { return }
           
           if isPaid == true {
               let items = order?.items.map {
                   OrderItem(mvariant_id: $0.mvariantId, quantity: $0.quantity, unit_price: $0.unitPrice)
               } ?? []

               let orderRequest = OrderRequest(
                   items: items,
                   user_company_address_id: order?.delivery.address_id ?? 0,
                   delivery_method_id: order?.delivery.method_id ?? 0,
                   coupon_discount: order?.summary.couponDiscount ?? 0.0,
                   wallet_discount: order?.summary.walletDiscount ?? 0.0
               )

               ApiService.shared.submitOrder(order: orderRequest) { result in
                   switch result {
                   case .success(let response):
                       print("Order placed: \(response)")
                       DispatchQueue.main.async {
                           let alert = UIAlertController(title: "Success", message: "Successfully Reordered", preferredStyle: .alert)
                           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                               // Optional: Navigate or dismiss after popup
                               self.navigationController?.popViewController(animated: true)
                               // or self.dismiss(animated: true)
                           })
                           self.present(alert, animated: true)
                       }
                   case .failure(let error):
                       print("Error placing order: \(error.localizedDescription)")
                       DispatchQueue.main.async {
                           self.showSimplePopup(title: "Error", message: "Failed to place reorder. Please try again.")
                       }
                   }
               }
           } else {
               ApiService().updateOrderStatus(orderId: orderId, status: "paid") { result in
                   DispatchQueue.main.async {
                       switch result {
                       case .success(let message):
                           print("✅", message)
                           self.isPaid = true
                           self.updateUIForPaymentStatus()
                           self.fetchOrder()
                       case .failure(let error):
                           print("❌ Failed to update order: \(error.localizedDescription)")
                           self.showSimplePopup(title: "Error", message: "Failed to complete payment. Please try again.")
                       }
                   }
               }
           }
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel Order",
                                      message: "Are you sure you want to cancel this order?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.cancelOrder()
        }))
        
        present(alert, animated: true)
    }
    
    private func cancelOrder() {
        guard let orderId = orderId else { return }
        
        ApiService().deleteOrder(orderId: "\(orderId)") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    print("✅ Success: \(message)")
                    self?.showSimplePopup(title: "Cancelled", message: "Order has been cancelled.") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                case .failure(let error):
                    print("❌ Error: \(error.localizedDescription)")
                    self?.showSimplePopup(title: "Error", message: "Failed to cancel the order. Please try again.")
                }
            }
        }
    }
    
    func showSimplePopup(title: String, message: String, completion: (() -> Void)? = nil) {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        popup.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(popup, animated: true)
    }
};

extension DetailOrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderCell") as? DetailOrderCell,
                  let item = order?.items[indexPath.row] else {
                return UITableViewCell()
            }

        cell.setCell(order: item) 
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
