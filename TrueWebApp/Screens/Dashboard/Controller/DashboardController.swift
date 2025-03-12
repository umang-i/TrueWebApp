//
//  DashboardController.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class DashboardController: UIViewController {
    
    // @IBOutlet weak var dashboardLabel: UILabel!
    @IBOutlet weak var recentOrderLabel: UILabel!
    @IBOutlet weak var recentNotifLabel: UILabel!
    @IBOutlet weak var referLabel: UILabel!
    @IBOutlet weak var referTextLabel: UILabel!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var referRewardView: UIView!
    @IBOutlet weak var notifHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var ordersTableView: UITableView!
    @IBOutlet weak var creditView: UIView!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var allOrdersButton: UIButton!
    // @IBOutlet weak var dashView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        setupTableViews()
        setupTapGesture()
    }
    
    func setupUI(){
        
        allOrdersButton.layer.borderWidth = 1
        allOrdersButton.layer.borderColor = UIColor.customBlue.cgColor
        allOrdersButton.layer.cornerRadius = 4
        allOrdersButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 16)
        
        creditView.layer.borderWidth = 1
        creditView.layer.borderColor = UIColor.customBlue.cgColor
        creditView.layer.cornerRadius = 4
        
        allOrdersButton.addTarget(self, action: #selector(allOrdersButtonTapped), for: .touchUpInside)
        referRewardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToReferView)))
        
        shopButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        favouriteButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        creditLabel.font =  UIFont(name: "Roboto-Medium", size: 16)
        referTextLabel.font =  UIFont(name: "Roboto-Medium", size: 20)
        referLabel.font =  UIFont(name: "Roboto-Medium", size: 14)
        recentNotifLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        recentOrderLabel.font = UIFont(name: "Roboto-Medium", size: 15)
    }
    
    func setupTableViews(){
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        notificationsTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToWallet))
        creditView.addGestureRecognizer(tapGesture)
        creditView.isUserInteractionEnabled = true
    }
    
    @objc func navigateToWallet() {
        let walletController = WalletViewController()
        self.navigationController?.pushViewController(walletController, animated: true)
    }
    
    @IBAction func allOrdersButtonTapped(_ sender: UIButton) {
        let orderController = OrdersController(nibName: "OrdersController", bundle: nil)
        self.navigationController?.pushViewController(orderController, animated: true)
    }
    
    @objc func navigateToReferView() {
        let referController = ReferRetailerViewController()
        self.navigationController?.pushViewController(referController, animated: true)
    }
    @IBAction func shopButtonAction(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableView == notificationsTableView ? 4 : 2// Number of cells (each cell is a section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has only one row
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView == notificationsTableView ? 15 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // Transparent spacing
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notificationsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else {
                return UITableViewCell()
            }
            
            // Add border radius and color
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.customBlue.cgColor
            cell.layer.borderWidth = 1.0
            
            // Configure cell content (if needed)
            // cell.configure(with: data[indexPath.section])
            
            return cell
        } else if tableView == ordersTableView {
            // Handle ordersTableView cells (if needed)
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell else {
                return UITableViewCell()
            }
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.customBlue.cgColor
            cell.layer.borderWidth = 0.6
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == notificationsTableView ? 50 : 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notificationsTableView {
            let detailVC = NotificationDetailController(nibName: "NotificationDetailController", bundle: nil)
            // detailVC.notification = data[indexPath.section]
            
            navigationController?.pushViewController(detailVC, animated: true)
        } else if tableView == ordersTableView{
            let detailOC = DetailOrderController()
            // detailVC.notification = data[indexPath.section]
    
            navigationController?.pushViewController(detailOC, animated: true)
        }
    }
}

