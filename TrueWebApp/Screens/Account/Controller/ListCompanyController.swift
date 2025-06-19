//
//  ListCompanyController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ListCompanyController: UIViewController, CustomNavBarDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var companyScrollView: UIScrollView!
    
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var newBranchButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    let loaderView = CustomLoaderView()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No Company Addresses"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    var companyAddresses: [CompanyAddress] = []
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Register the cell with XIB
            listTableView.register(UINib(nibName: "ListCompanyCell", bundle: nil), forCellReuseIdentifier: "ListCompanyCell")
            listTableView.delegate = self
            listTableView.dataSource = self
        
        newBranchButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)!
        setnavBar()
    
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCompanyAddresses()
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
                    self.emptyLabel.isHidden = !addresses.isEmpty
                    self.listTableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch addresses:", error.localizedDescription)
                }
            }
        }
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "My Address")
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
    
    @IBAction func newBranchButton(_ sender: Any) {
        let companyController = MyCompanyController(
            user_company_address_id: 0,
            companyName: "",
            addressLine1: "",
            addressLine2: "",
            city: "",
            county: "",
            postcode: "",
            num: 0,
            companyAddresses: self.companyAddresses // Pass existing addresses
        )
        self.navigationController?.pushViewController(companyController, animated: true)
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self // So we can allow simultaneous gestures
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: companyScrollView)

        if companyScrollView.contentOffset.y <= 0 && translation.y > 100 && loaderView.isHidden {
            print("🔄 Triggering custom refresh")
            beginCustomRefresh()
        }
    }
    var isRefreshing = false

    func beginCustomRefresh() {
        loaderView.isHidden = false
        view.bringSubviewToFront(loaderView)
        loaderView.startAnimating() // ✅ START animation
        self.loadCompanyAddresses()
        self.listTableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.endCustomRefresh()
        }
    }

    func endCustomRefresh() {
        loaderView.stopAnimating() // ✅ STOP animation
        loaderView.isHidden = true
    }
}

extension ListCompanyController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return companyAddresses.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCompanyCell", for: indexPath) as? ListCompanyCell else {
            return UITableViewCell()
        }

        let company = companyAddresses[indexPath.section]

        // Build the full address string safely
        var fullAddress = company.company_address1
        if let addr2 = company.company_address2 {
            fullAddress += ", \(addr2)"
        }
        fullAddress += ", \(company.company_city), \(company.company_country), \(company.company_postcode)"

        cell.configure(with: fullAddress)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // Handle cell tap to navigate to MyCompanyController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let company = companyAddresses[indexPath.section]
        let companyController = MyCompanyController(
            user_company_address_id: company.user_company_address_id, companyName: company.user_company_name,
            addressLine1: company.company_address1,
            addressLine2: company.company_address2 ?? "",
            city: company.company_city,
            county: company.company_country,
            postcode: company.company_postcode,
            num: 1, companyAddresses: companyAddresses
        )
        self.navigationController?.pushViewController(companyController, animated: true)
    }
}

// Safe array access extension to prevent crashes
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
