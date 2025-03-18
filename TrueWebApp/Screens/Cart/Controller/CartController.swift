//
//  CartController.swift
//  TrueApp
//
//  Created by Umang Kedan on 25/02/25.
//

import UIKit

class CartController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var cartScrollView: UIScrollView!
    var tableViewHeightConstraint: NSLayoutConstraint?
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var cartTableView: UITableView!
    
    var cartItems: [String] = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 3", "Item 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setnavBar()
    }
    
    func setTableView() {
            cartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
            cartTableView.delegate = self
            cartTableView.dataSource = self
            cartTableView.separatorStyle = .none
            cartTableView.rowHeight = UITableView.automaticDimension
            cartTableView.isScrollEnabled = false
            tableViewHeightConstraint = cartTableView.heightAnchor.constraint(equalToConstant: 0)
            tableViewHeightConstraint?.isActive = true
            amountView.layer.shadowColor = UIColor.black.cgColor
            amountView.layer.shadowOffset = CGSize(width: 0, height: -3)
            amountView.layer.shadowOpacity = 0.5
            amountView.layer.shadowRadius = 4.0
            amountView.layer.masksToBounds = false
            updateTableViewHeight() // Update height after setting up
        }

        func updateTableViewHeight() {
            cartTableView.layoutIfNeeded()
            var totalHeight: CGFloat = 0
            for section in 0..<cartTableView.numberOfSections {
                for row in 0..<cartTableView.numberOfRows(inSection: section) {
                    let indexPath = IndexPath(row: row, section: section)
                    totalHeight += cartTableView.rectForRow(at: indexPath).height
                }
            }
            tableViewHeightConstraint?.constant = totalHeight + 100
        }
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Cart")
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
    @IBAction func checkoutButtonAction(_ sender: Any) {
        let vc = CheckOutController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

    extension CartController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            cartItems.count
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell") as? CartCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            updateTableViewHeight()
        }

        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            return UIView()
        }
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            return 10
        }
    }

extension CartController : CartCellDelegate{
    
    func didTapDeleteButton(in cell: CartCell) {
        guard let indexPath = cartTableView.indexPath(for: cell) else { return }
        cartItems.remove(at: indexPath.row) // Remove item from data source
        cartTableView.deleteRows(at: [indexPath], with: .automatic) // Remove cell from table
        updateTableViewHeight()
    }
}
