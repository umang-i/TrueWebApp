//
//  ServiceController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ServiceController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    var headings = ["Basic POS ", "Advance POS","Premium POS"]
    var subheadings = ["Free with min app spend £2000 + VAT pcm", "Free with min app spend £3000 + VAT pcm","Free with min app spend £5000 + VAT pcm"]
    let posItems: [POSModel] = [
            POSModel(
                title: "Basic POS",
                subtitle: "Free with min app spend £2000 + VAT pcm",
                imageName: "img", // Make sure you add this image in your Assets
                features: [
                    "Compare and get real time business analytics",
                    "Fast & Easy Billing",
                    "Discount & Promotions Management",
                    "Price management from Head office",
                    "Rack Management",
                    "Retail Customer Relationship Management"
                ]
            ),POSModel(
                title: "Advance POS",
                subtitle: "Free with min app spend £2000 + VAT pcm",
                imageName: "img", // Make sure you add this image in your Assets
                features: [
                    "Compare and get real time business analytics",
                    "Fast & Easy Billing",
                    "Discount & Promotions Management",
                    "Price management from Head office",
                    "Rack Management",
                    "Retail Customer Relationship Management"
                ]
            ),POSModel(
                title: "Premium POS",
                subtitle: "Free with min app spend £2000 + VAT pcm",
                imageName: "img", // Make sure you add this image in your Assets
                features: [
                    "Compare and get real time business analytics",
                    "Fast & Easy Billing",
                    "Discount & Promotions Management",
                    "Price management from Head office",
                    "Rack Management",
                    "Retail Customer Relationship Management"
                ]
            )
        ]
    
    @IBOutlet weak var itemScrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var servicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        servicesTableView.separatorStyle = .none
        setnavBar()
        servicesTableView.isScrollEnabled = false
        
        // Register ServiceCell properly
//        servicesTableView.register(UINib(nibName: "ServiceCell", bundle: nil), forCellReuseIdentifier: "ServiceCell")
        servicesTableView.register(ServiceCell.self, forCellReuseIdentifier: "ServiceCell")
        
        // Adjust height after layout updates
        DispatchQueue.main.async {
            self.updateTableViewHeight()
        }
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Services")
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
    
    private func updateTableViewHeight() {
            let rowCount = servicesTableView.numberOfRows(inSection: 0)
            let rowHeight: CGFloat = 650
            let totalHeight = rowHeight * CGFloat(rowCount)
            
            tableViewHeightConstraint.constant = totalHeight // Update the height constraint
           
            let scrollViewContentHeight = totalHeight + 200
            itemScrollView.contentSize = CGSize(width: itemScrollView.frame.width, height: scrollViewContentHeight)
            
            view.layoutIfNeeded() // Apply changes
        }
}

    extension ServiceController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceCell else {
                return UITableViewCell()
            }
            cell.configure(with: posItems[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            updateTableViewHeight()
        }
    }
