//
//  OrdersController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class OrdersController: UIViewController, CustomNavBarDelegate , OrderCellDelegate {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var orderScrollView: UIScrollView!
    var isLoading = true
    let loaderView = CustomLoaderView()

    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    func didTapReorderButton(on cell: OrderCell) {
        self.fetchData()
        self.ordersTableView.reloadData()
        let alert = UIAlertController(title: "Order Placed", message: "Your reorder has been successfully placed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var orders : [Order] = []
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        ordersTableView.register(ShimmerCell.self, forCellReuseIdentifier: "ShimmerCell")
        
        setnavBar()
        setupLoaderView()
        addPanGestureLoader()
        fetchData()
    }
    
    func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true
        view.addSubview(loaderView)
        view.bringSubviewToFront(loaderView) // ✅ Ensures it's above all other views

        NSLayoutConstraint.activate([
            loaderView.topAnchor.constraint(equalTo: view.topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func addPanGestureLoader() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.cancelsTouchesInView = false
        orderScrollView.addGestureRecognizer(panGesture)
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: ordersTableView)
        
        if velocity.y > 0 && gesture.state == .began && !isLoading {
            showLoaderAndFetch()
        }
    }
    
    func showLoaderAndFetch() {
        isLoading = true
        loaderView.isHidden = false
        fetchData()
    }

    func showShimmer() {
        isLoading = true
        orders = []
        ordersTableView.reloadData()
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
        isLoading = true
        ordersTableView.reloadData()
        
        ApiService.shared.fetchOrders { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let orders):
                    print("✅ Orders fetched:", orders)
                    self.isLoading = false
                    self.loaderView.isHidden = true // ✅ Hide the loader here
                    self.orders = orders
                    self.ordersTableView.reloadData()
                    self.updateTableViewHeight()
                    self.updateEmptyState()
                    
                case .failure(let error):
                    print("❌ Failed to fetch orders:", error.localizedDescription)
                    self.isLoading = false
                    self.loaderView.isHidden = true // ✅ Also hide loader on failure
                    // Optional: show alert
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
        return isLoading ? 5 :  orders.count
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
        if isLoading {
            guard let shimmerCell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell") as? ShimmerCell else {
                return UITableViewCell()
            }
            return shimmerCell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell") as? OrderCell else {
            return UITableViewCell()
        }
        cell.setCell(order: orders[indexPath.section])
        cell.layer.cornerRadius = 4
        cell.delegate = self
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
        detailOC.isPaid = orders[indexPath.section].paymentStatus == "paid"
        detailOC.orderId = orders[indexPath.section].orderId
        navigationController?.pushViewController(detailOC, animated: true)
    }
}
