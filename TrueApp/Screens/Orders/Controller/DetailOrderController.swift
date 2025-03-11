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
    @IBOutlet weak var paymentTotalTextLAbel: UILabel!
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
    
    var isPaid: Bool = true
    
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
    
    func updateUIForPaymentStatus() {
            if isPaid {
                cancelOrderButton.isHidden = true
                completePaymentButton.backgroundColor = UIColor.customBlue // Replace with your custom blue color
                completePaymentButton.setTitle("Reorder Items", for: .normal)
                completePaymentButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
                // Increase button height (if using Auto Layout)
                if let heightConstraint = (completePaymentButton.constraints.filter { $0.firstAttribute == .height }.first) {
                    heightConstraint.constant = 55 // Adjust height as needed
                }
                completePaymentButton.layer.cornerRadius = 4


            } else {
                cancelOrderButton.isHidden = false
                completePaymentButton.backgroundColor = .systemBlue // Or your default color
                completePaymentButton.setTitle("Complete Payment", for: .normal)
                completePaymentButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 15)
                // Reset height if you changed it
                if let heightConstraint = (completePaymentButton.constraints.filter { $0.firstAttribute == .height }.first) {
                    heightConstraint.constant = 44 // Or your default height
                }
            }
            completePaymentButton.layoutIfNeeded() //update layout
        }
};

extension DetailOrderController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailOrderCell") as? DetailOrderCell else {
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
