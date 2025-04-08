//
//  ListCompanyController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ListCompanyController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var newBranchButton: UIButton!
    @IBOutlet weak var listTableView: UITableView!
    
    let companyAddresses = [
            "Immzy  LTd 78 , Stockport Road , Ashton-under-lyne,Greater Manchester , OL7 , Ol8",
            "456 OImmzy  LTd 78 , Stockport Road , Ashton-under-lyne,Greater Manchester , OL7 , Ol8 ak Avenue, Los Angeles, CA",
            "Immzy  LTd 78 , Stockport Road , Ashton-under-lyne,Greater Manchester , OL7 , Ol8 " ,
            "Immzy  LTd 78 , Stockport Road , Ashton-under-lyne,Greater Manchester , OL7 , Ol8",
            "Immzy  LTd 78 , Stockport Road , Ashton-under-lyne,Greater Manchester , OL7 , Ol8",]
    
    override func viewDidLoad() {
            super.viewDidLoad()

            // Register the cell with XIB
            listTableView.register(UINib(nibName: "ListCompanyCell", bundle: nil), forCellReuseIdentifier: "ListCompanyCell")

            listTableView.delegate = self
            listTableView.dataSource = self
        
        newBranchButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 17)!
        setnavBar()
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
        let companyController = MyCompanyController(companyName: "", addressLine1: "", addressLine2: "", city: "", county: "", postcode: "" , num: 0)
        self.navigationController?.pushViewController(companyController, animated: true)
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
        // Set the address for each cell
        cell.configure(with: companyAddresses[indexPath.section])
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
        let addressComponents = companyAddresses[indexPath.section].components(separatedBy: ", ")
        
        let companyController = MyCompanyController(
            companyName: addressComponents[safe: 0] ?? "", // You can modify this to get the actual company name
            addressLine1: addressComponents[safe: 0] ?? "",
            addressLine2: addressComponents[safe: 1] ?? "",
            city: addressComponents[safe: 2] ?? "",
            county: addressComponents[safe: 3] ?? "",
            postcode: addressComponents[safe: 4] ?? "",
            num: 1 
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
