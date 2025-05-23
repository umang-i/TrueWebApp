//
//  AccountController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class AccountController: UIViewController {

    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var accDetailsTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
        private let activityIndicator = UIActivityIndicatorView(style: .large)

        let accountItems: [AccountItem] = [
            AccountItem(title: "My Rep Details", iconName: "rep"),
            AccountItem(title: "My Orders", iconName: "bag1"),
            AccountItem(title: "Loyalty Rewards", iconName: "reward"),
            AccountItem(title: "My Address", iconName: "company"),
            AccountItem(title: "Payment Options", iconName: "card"),
            AccountItem(title: "Service & Display Solutions", iconName: "service"),
            AccountItem(title: "Profile", iconName: "user_fill"),
            AccountItem(title: "Wallet", iconName: "wallet_fill"),
            AccountItem(title: "Notification Preferences", iconName: "bell"),
            AccountItem(title: "Change Password", iconName: "lock"),
            AccountItem(title: "Terms and Conditions", iconName: "contract"),
            AccountItem(title: "Privacy Policy", iconName: "privacy"),
            AccountItem(title: "Logout", iconName: "logout"),
            AccountItem(title: "Delete Account", iconName: "bin"),
        ]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupTableView()
            setupRefreshControl()
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }

        func setupTableView() {
            accDetailsTableView.delegate = self
            accDetailsTableView.dataSource = self
            accDetailsTableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "AccountCell")
            accDetailsTableView.separatorStyle = .none
        }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            detailScrollView.refreshControl = refreshControl
        } else {
            detailScrollView.addSubview(refreshControl)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        detailScrollView.contentSize = CGSize(width: view.frame.width, height: accDetailsTableView.frame.maxY + 20)
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.accDetailsTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension AccountController: UITableViewDelegate, UITableViewDataSource {
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountItems.count
    }
    
    // Configure the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath) as! AccountCell
        let data = accountItems[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: data.iconName)?.withRenderingMode(.alwaysTemplate)
        cell.iconImageView.tintColor = .customBlue
        cell.textLabelView.text = data.title
        
        // Apply spacing effect with shadow
        cell.containerView.layer.cornerRadius = 4
        cell.containerView.layer.borderWidth = 1
        cell.containerView.layer.borderColor = UIColor.customBlue.cgColor
        cell.containerView.layer.masksToBounds = false
        cell.containerView.layer.shadowColor = UIColor.black.cgColor
        cell.containerView.layer.shadowOpacity = 0.1
        cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.containerView.layer.shadowRadius = 4
        
        return cell
    }
    
    // Height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // Add spacing between cells using footer height
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselect the row
        
        let selectedItem = accountItems[indexPath.row]
        
        if selectedItem.title == "My Rep Details" {
            let repDetailController = RepDetailController(nibName: "RepDetailController", bundle: nil)
            self.navigationController?.pushViewController(repDetailController, animated: true)
        } else if selectedItem.title == "Change Password"{
            let passwordController = PasswordController()
            self.navigationController?.pushViewController(passwordController, animated: true)
        } else if selectedItem.title == "Notification Preferences"{
            let notifController = NotificationController()
            self.navigationController?.pushViewController(notifController, animated: true)
        }else if selectedItem.title == "Wallet"{
            let walletController = WalletViewController()
            self.navigationController?.pushViewController(walletController, animated: true)
        } else if selectedItem.title == "My Address" {
            let companyController = ListCompanyController()
            self.navigationController?.pushViewController(companyController, animated: true)
        } else if selectedItem.title == "Service & Display Solutions" {
            let serviceController = ServiceController()
            self.navigationController?.pushViewController(serviceController, animated: true)
        }else if selectedItem.title == "Profile" {
            let profileController = ProfileController()
            self.navigationController?.pushViewController(profileController, animated: true)
        }else if selectedItem.title == "Logout" {
            showLogoutAlert(on: self)
        }else if selectedItem.title == "Delete Account" {
            showDeleteAlert(on: self)
        }else if selectedItem.title == "My Orders"{
            let ordersController = OrdersController()
            self.navigationController?.pushViewController(ordersController, animated: true)
        }else if selectedItem.title == "Payment Options"{
            let paymentController = PaymentOptionsController(nibName: "PaymentOptionsController", bundle: nil)
            self.navigationController?.pushViewController(paymentController, animated: true)
        }else if selectedItem.title == "Loyalty Rewards"{
            let rewardController = RewardsController(nibName: "RewardsController", bundle: nil)
            self.navigationController?.pushViewController(rewardController, animated: true)
        }else if selectedItem.title == "Terms and Conditions" || selectedItem.title == "Privacy Policy" {
            let vc = HTMLPageViewController()
            vc.pageType = selectedItem.title == "Terms and Conditions" ? .terms : .privacy
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

