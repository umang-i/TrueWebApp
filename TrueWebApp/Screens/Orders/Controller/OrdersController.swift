//
//  OrdersController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class OrdersController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var orders : [Order] = []

    @IBOutlet weak var ordersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        setnavBar()
        fetchData()
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Orders")
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
    
    func fetchData(){
        ApiService.shared.fetchOrders { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    print("✅ Orders fetched:", orders)
                    DispatchQueue.main.async {
                        self.orders = orders
                        self.ordersTableView.reloadData()
                        self.updateTableViewHeight()
                        self.updateEmptyState()
                    }

                case .failure(let error):
                    print("❌ Failed to fetch orders:", error.localizedDescription)
                    // Show alert
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func updateEmptyState() {
        if orders.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "No order found"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            emptyLabel.numberOfLines = 0

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.ordersTableView.backgroundView = emptyLabel
            }

        } else {
            ordersTableView.backgroundView = nil
        }
    }
    
    func updateTableViewHeight() {
        let cellHeight: CGFloat = 200
        let footerHeight: CGFloat = 10
        let totalHeight = CGFloat(orders.count) * (cellHeight + footerHeight)
        tableViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }

}
extension OrdersController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return  10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // Transparent spacing
        return footerView
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell else {
            return UITableViewCell()
        }
        cell.setCell(order: orders[indexPath.section])
        cell.layer.cornerRadius = 4
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.customBlue.cgColor
        cell.layer.borderWidth = 0.6
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailOC = DetailOrderController()
        detailOC.isPaid = orders[indexPath.row].status != "pending"
        detailOC.orderId = orders[indexPath.row].orderId
        navigationController?.pushViewController(detailOC, animated: true)
    }
}
