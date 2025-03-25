//
//  PaymentOptionsController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 25/03/25.
//

import UIKit

struct PaymentMethod {
    let icon: String?
    let name: String
    var details: String?
}

class PaymentOptionsController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var savedTableView: UITableView!

    let savedPaymentMethods = [
        PaymentMethod(icon: "mastercard", name: "Mastercard", details: "•••• 1444"),
        PaymentMethod(icon: "mastercard", name: "Visa", details: "•••• 5678")
    ]

    let addPaymentMethods = [
        PaymentMethod(icon: "gpay", name: "Google Pay"),
        PaymentMethod(icon: "paypal", name: "PayPal"),
        PaymentMethod(icon: "applePay", name: "Apple Pay"),
        PaymentMethod(icon: "credit_card", name: "Credit/Debit Card")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Payment Options"

        savedTableView.delegate = self
        savedTableView.dataSource = self
        addTableView.delegate = self
        addTableView.dataSource = self
        addTableView.separatorStyle = .none
        savedTableView.separatorStyle = .none

        savedTableView.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
        addTableView.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
        setnavBar()
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
}

extension PaymentOptionsController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == savedTableView ? savedPaymentMethods.count : addPaymentMethods.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell

        let method = tableView == savedTableView ? savedPaymentMethods[indexPath.section] : addPaymentMethods[indexPath.section]
        let arrow = tableView == savedTableView // Arrow only for saved payments
        cell.setCell(
            img: method.icon ?? "",
            text: tableView == savedTableView ? "\(method.name) \(method.details ?? "")" : method.name,
            isArrow: arrow
        )
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 // Cell height
    }

    // Add spacing between sections
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10 // Space between cells
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacerView = UIView()
        spacerView.backgroundColor = .clear
        return spacerView
    }
}
