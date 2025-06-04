//
//  PaymentViewController.swift
//  TrueApp
//
//  Created by Umang Kedan on 04/03/25.
//

import UIKit

class PaymentViewController: UIViewController, CustomNavBarDelegate {
    @IBOutlet weak var cvvTextField: UITextField!
    @IBOutlet weak var expireTextField: UITextField!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var cardholderNameTf: UITextField!
    
    var deliveryId : Int!
    var addressId : Int!
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var bankRadioView: UIView!
    @IBOutlet weak var cardRadioView: UIView!
    @IBOutlet weak var bankDropDownButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var bankView: UIView!
    @IBOutlet weak var cardRadioButton: UIView!
    @IBOutlet weak var bankRadioButton: UIView!
    
    @IBOutlet weak var cardViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bankViewHeightConstraint: NSLayoutConstraint!
    
    let bankList = ["Bank of America", "Chase Bank", "Wells Fargo", "Citi Bank", "Capital One"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavBar()
        
        bankDropDownButton.setTitle("Select Bank", for: .normal)
        bankDropDownButton.addTarget(self, action: #selector(showBankDropdown), for: .touchUpInside)
        bankDropDownButton.layer.borderColor = UIColor.customBlue.cgColor
        bankDropDownButton.layer.borderWidth = 1
        bankDropDownButton.layer.cornerRadius = 4
        
        bankRadioButton.layer.borderColor = UIColor.customRed.cgColor
        bankRadioButton.layer.borderWidth =     1
        cardRadioButton.layer.borderColor = UIColor.customRed.cgColor
        cardRadioButton.layer.borderWidth = 1
        cardRadioView.backgroundColor = UIColor.white
        bankRadioView.backgroundColor = .customRed
        
        bankView.layer.borderWidth = 1
        bankView.layer.cornerRadius = 4
        bankView.layer.borderColor = UIColor.customBlue.cgColor
        
        cardholderNameTf.layer.borderWidth = 1
        cardholderNameTf.layer.cornerRadius = 4
        cardholderNameTf.layer.borderColor = UIColor.customBlue.cgColor
        
        cardNameTextField.layer.borderWidth = 1
        cardNameTextField.layer.cornerRadius = 4
        cardNameTextField.layer.borderColor = UIColor.customBlue.cgColor
        
        expireTextField.layer.borderWidth = 1
        expireTextField.layer.cornerRadius = 4
        expireTextField.layer.borderColor = UIColor.customBlue.cgColor
        
        cvvTextField.layer.borderWidth = 1
        cvvTextField.layer.cornerRadius = 4
        cvvTextField.layer.borderColor = UIColor.customBlue.cgColor
        
        cardViewHeightConstraint.constant = -100
        bankViewHeightConstraint.constant = 223
        cardView.isHidden = true
        
        // Add tap gestures for toggling views
        let cardTapGesture = UITapGestureRecognizer(target: self, action: #selector(cardSelected))
        cardRadioButton.addGestureRecognizer(cardTapGesture)
        
        let bankTapGesture = UITapGestureRecognizer(target: self, action: #selector(bankSelected))
        bankRadioButton.addGestureRecognizer(bankTapGesture)
    }
    
    @objc func cardSelected() {
        cardRadioView.backgroundColor = .customRed
        bankRadioView.backgroundColor = .white
        cardView.isHidden = false
        bankView.isHidden = true
        cardView.layer.borderWidth = 1
        cardView.layer.cornerRadius = 4
        cardView.layer.borderColor = UIColor.customBlue.cgColor
        toggleView(expand: cardView, shrink: bankView, expandedHeight: 290 , shrunkHeight: 0 )
    }
    
    @objc func bankSelected() {
        bankRadioView.backgroundColor = .customRed
        cardRadioView.backgroundColor = .white
        cardView.isHidden = true
        bankView.isHidden = false
        toggleView(expand: bankView, shrink: cardView, expandedHeight: 223, shrunkHeight: -100)
    }
    @objc func showBankDropdown() {
        let alertController = UIAlertController(title: "Select Bank", message: nil, preferredStyle: .actionSheet)
        
        for bank in bankList {
            let action = UIAlertAction(title: bank, style: .default) { _ in
                self.bankDropDownButton.setTitle(bank, for: .normal)
                print("Selected Bank: \(bank)")
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func toggleView(expand: UIView, shrink: UIView, expandedHeight: CGFloat, shrunkHeight: CGFloat) {
        UIView.animate(withDuration: 0.3, animations: {
            if expand == self.cardView {
                self.cardViewHeightConstraint.constant = expandedHeight
                self.bankViewHeightConstraint.constant = shrunkHeight
            } else {
                self.cardViewHeightConstraint.constant = shrunkHeight
                self.bankViewHeightConstraint.constant = expandedHeight
            }
            self.view.layoutIfNeeded()
        })
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Payment Options")
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
    @IBAction func completePaymentAction(_ sender: Any) {
        CartManager.shared.loadCartFromLocalStorage()

           let cartItems = CartManager.shared.getAllCartItems()

           // Convert to array of OrderItem
           let items: [OrderItem] = cartItems.map { (mvariantId, item) in
               return OrderItem(mvariant_id: mvariantId, quantity: item.quantity, unit_price: item.price)
           }

           guard !items.isEmpty else {
               print("❌ Cannot submit order: cart is empty.")
               // Optionally show an alert here
               return
           }
        
        let order = OrderRequest(
               items: items,
               user_company_address_id: addressId,
               delivery_method_id: deliveryId
           )
        
        ApiService.shared.submitOrder(order: order) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Order submitted:", response)
                    let vc = OrderConfirmationViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                case .failure(let error):
                    print("Order failed:", error.localizedDescription)
                    // Optionally show alert
                }
            }
        }
    }
}

