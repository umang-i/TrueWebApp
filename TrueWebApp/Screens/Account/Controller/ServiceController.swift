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
    
    var serviceSolutions: [ServiceSolution] = []
    var isLoading = true
    let shimmerCount = 3
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No services"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()

    @IBOutlet weak var itemScrollView: UIScrollView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var servicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchServices()
        setuptableView()
        setnavBar()
        
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func fetchServices() {
        ApiService.shared.fetchServiceSolutions { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let solutions):
                    self.serviceSolutions = solutions
                    self.isLoading = false
                    self.emptyLabel.isHidden = !solutions.isEmpty
                    self.servicesTableView.reloadData()
                    self.updateTableViewHeight()
                case .failure(let error):
                    print("❌ Error fetching solutions:", error.localizedDescription)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchServices()
    }
    
    func setuptableView(){
        servicesTableView.delegate = self
        servicesTableView.dataSource = self
        servicesTableView.separatorStyle = .none
        servicesTableView.isScrollEnabled = false
        servicesTableView.register(ServiceCell.self, forCellReuseIdentifier: "ServiceCell")
        servicesTableView.register(ShimmerCell.self, forCellReuseIdentifier: "ShimmerCell")
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
            return isLoading ? shimmerCount : serviceSolutions.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if isLoading {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath) as! ShimmerCell
                cell.selectionStyle = .none
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as? ServiceCell else {
                    return UITableViewCell()
                }
                let item = serviceSolutions[indexPath.row]
                cell.configure(with: item)
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
        
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            updateTableViewHeight()
        }
    }
