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
    func didSelectDeliveryOption(_ cell: MethodDeliveryCell) {
        if let indexPath = methodTableView.indexPath(for: cell) {
            selectedMethodIndex = indexPath.row
            methodTableView.reloadData()
        } else if let indexPath = locationTableView.indexPath(for: cell) {
            selectedLocationIndex = indexPath.row
            locationTableView.reloadData()
        }
    }
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private let deliveryOptions = [
            ("Next Working Day Delivery - Estimated: Tomorrow (£5.00)"),
            ("Standard Delivery - Estimated: 2-4 Working Days (£3.00)")
        ]
    private let deliveryLocation = [
        ("Immyz Ltd - 123 Main Street , Ashton under layne LS12 3AB"),
        ("Immyz Ltd - 123 Main Street ,Ashton under layne LS12 3AB 2 3")
    ]
    
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
        print("hi")
        let vc = PaymentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CheckOutController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == methodTableView ? deliveryOptions.count : deliveryLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MethodDeliveryCell", for: indexPath) as? MethodDeliveryCell else {
            return UITableViewCell()
        }
        
        if tableView == methodTableView {
            let title = deliveryOptions[indexPath.row]
            let isSelected = selectedMethodIndex == indexPath.row
            cell.configure(with: title, isSelected: isSelected)
        } else {
            let title = deliveryLocation[indexPath.row]
            let isSelected = selectedLocationIndex == indexPath.row
            cell.configure(with: title , isSelected: isSelected)
        }
        
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
