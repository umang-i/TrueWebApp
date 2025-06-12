//
//  CheckOutController.swift
//  TrueApp
//
//  Created by Umang Kedan on 27/02/25.
//

import UIKit

class CheckOutController: UIViewController, CustomNavBarDelegate, MethodDeliveryCellDelegate {
    
    @IBOutlet weak var couponTextField: UITextField!
    @IBOutlet weak var deliveryTextField: UITextField!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var couponDiscount: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var skuLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    private var selectedDeliveryMethodID: Int?
    private var selectedCompanyAddressID: Int?
    
    var vat : String!
    var subtotal : String!
    var discount : String!
    var payment: String!
    var units : String!
    var skus : String!
    
    func didSelectDeliveryOption(_ cell: MethodDeliveryCell) {
        if let indexPath = methodTableView.indexPath(for: cell) {
            selectedMethodIndex = indexPath.row
            selectedDeliveryMethodID = deliveryMethods[indexPath.row].delivery_method_id
            methodTableView.reloadData()
        } else if let indexPath = locationTableView.indexPath(for: cell) {
            selectedLocationIndex = indexPath.row
            selectedCompanyAddressID = companyAddresses[indexPath.row].user_company_address_id
            locationTableView.reloadData()
        }
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private var deliveryMethods: [MethodDelivery] = []
    var companyAddresses: [CompanyAddress] = []
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var methodTableView: UITableView!
    @IBOutlet weak var continuePaymentButton: UIButton!
    @IBOutlet weak var orderSummaryView: UIView!
    
    private var selectedMethodIndex: Int?
    private var selectedLocationIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavBar()
        setupTableView()
        setUi()
        fetchMethods()
        loadCompanyAddresses()
    }
    
    func setUi(){
        orderSummaryView.layer.borderWidth = 1
        orderSummaryView.layer.borderColor = UIColor.customBlue.cgColor
        orderSummaryView.layer.cornerRadius = 4
        
        locationTableView.layer.borderWidth = 1
        locationTableView.layer.borderColor = UIColor.customBlue.cgColor
        locationTableView.layer.cornerRadius = 4
        
        methodTableView.layer.borderWidth = 1
        methodTableView.layer.borderColor = UIColor.customBlue.cgColor
        methodTableView.layer.cornerRadius = 4
        
        deliveryTextField.layer.borderWidth = 1
        deliveryTextField.layer.borderColor = UIColor.customBlue.cgColor
        deliveryTextField.layer.cornerRadius = 4
        
        couponTextField.layer.borderWidth = 1
        couponTextField.layer.borderColor = UIColor.customBlue.cgColor
        couponTextField.layer.cornerRadius = 4
        
        vatLabel.text = vat
        paymentLabel.text = payment
        subtotalLabel.text = subtotal
        discountLabel.text = discount
        unitLabel.text = units
        skuLabel.text = skus
    }
    
    func loadCompanyAddresses() {
        guard let authToken = UserDefaults.standard.string(forKey: "authToken"), !authToken.isEmpty else {
            print("User not logged in.")
            return
        }

        ApiService().fetchCompanyAddresses(authToken: authToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let addresses):
                    self.companyAddresses = addresses
                    self.locationTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch addresses:", error.localizedDescription)
                }
            }
        }
    }
    
    func fetchMethods() {
        ApiService().fetchDeliveryMethods { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let methods):
                    self?.deliveryMethods = methods
                    self?.methodTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch methods:", error.localizedDescription)
                    // Optional: Show an alert to the user
                }
            }
        }
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Checkout")
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
    
    private func setupTableView() {
        methodTableView.delegate = self
        methodTableView.dataSource = self
        methodTableView.register(MethodDeliveryCell.self, forCellReuseIdentifier: "MethodDeliveryCell")
        methodTableView.separatorStyle = .none
        
        locationTableView.delegate = self
        locationTableView.dataSource = self
        locationTableView.register(MethodDeliveryCell.self, forCellReuseIdentifier: "MethodDeliveryCell")
        locationTableView.separatorStyle = .none
        }
    
    
    @IBAction func paymentButtonAction(_ sender: Any) {
        guard let methodID = selectedDeliveryMethodID,
                  let addressID = selectedCompanyAddressID else {
                // Optionally show an alert if selection is incomplete
                let alert = UIAlertController(title: "Selection Required", message: "Please select a delivery method and address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                return
            }

            print("Selected delivery method ID: \(methodID)")
            print("Selected address ID: \(addressID)")
        
        let vc = PaymentViewController()
        vc.deliveryId = methodID
        vc.addressId = addressID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func applyButtonAction(_ sender: Any) {
        if let couponCode = couponTextField.text, !couponCode.isEmpty {
            ApiService().applyCoupon(couponCode) { result in
                switch result {
                case .success(let coupon):
                    DispatchQueue.main.async {
                        if coupon.status {
                            self.couponDiscount.text = "\(coupon.discount ?? 0)"
                            self.subtotalLabel.text = "\(coupon.newTotal ?? 0)"
                            self.showAlert(title: "Success", message: coupon.message)
                        } else {
                            self.showAlert(title: "Error", message: coupon.message)
                        }
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(title: "Failed", message: "The Coupon Code is not valid \(error)")
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension CheckOutController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == methodTableView ? deliveryMethods.count : companyAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MethodDeliveryCell", for: indexPath) as? MethodDeliveryCell else {
            return UITableViewCell()
        }
        
        if tableView == methodTableView {
            let method = deliveryMethods[indexPath.row]
            let title = "\(method.delivery_method_name) - £\(method.delivery_method_amount)"
            let isSelected = selectedMethodIndex == indexPath.row
            cell.configure(with: title, isSelected: isSelected)
        } else {
            let address = companyAddresses[indexPath.row]
            let title = "\(address.company_address1),\(address.company_address2 ?? ""),\(address.company_city),\(address.company_postcode)"
            let isSelected = selectedLocationIndex == indexPath.row
            cell.configure(with: title , isSelected: isSelected)
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == methodTableView ? 40 : 35
    }
}
