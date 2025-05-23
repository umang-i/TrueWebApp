//
//  ProfileController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ProfileController: UIViewController, CustomNavBarDelegate {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var repcodeTextLabel: UILabel!
    @IBOutlet weak var repCodeLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var emailLabelText: UILabel!
    @IBOutlet weak var phoneNumberTextLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var companyLAbelTextLAbel: UILabel!
    @IBOutlet weak var companyAddressLAbel: UILabel!
    @IBOutlet weak var companyNameText: UILabel!
    @IBOutlet weak var companyNameLAbel: UILabel!
    
    private var loadingIndicator: UIActivityIndicatorView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavBar()
            setupFonts()
            fetchUserData()
        }

        // MARK: - NavBar
        func setupNavBar() {
            let topBackgroundView = UIView()
            topBackgroundView.backgroundColor = .white
            topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(topBackgroundView)

            let navBar = CustomNavBar(text: "Profile")
            navBar.delegate = self
            navBar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(navBar)

            NSLayoutConstraint.activate([
                topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                topBackgroundView.heightAnchor.constraint(equalToConstant: 100),
                
                navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navBar.heightAnchor.constraint(equalToConstant: 50)
            ])
        }

        // MARK: - Font Styling
        func setupFonts() {
            usernameLabel.font = UIFont(name: "Roboto-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
            repCodeLabel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            repcodeTextLabel.font = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            emailLabelText.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            emailTextLabel.font = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            phoneNumberLabel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            phoneNumberTextLabel.font = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            companyNameLAbel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            companyNameText.font = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
            companyAddressLAbel.font = UIFont(name: "Roboto-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
            companyLAbelTextLAbel.font = UIFont(name: "Roboto-Medium", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        }

        // MARK: - Fetch User Data
    func fetchUserData() {
        showLoadingIndicator()

        if let savedUser = loadUserFromDefaults() {
            self.updateUI(with: savedUser)
            self.hideLoadingIndicator()
        } else {
print("no data")
        }
    }

        // MARK: - Update UI
        func updateUI(with user: User1) {
            usernameLabel.text = user.name
            repcodeTextLabel.text = user.rep_code ?? "N/A" // Handle nil case for rep_code
            emailTextLabel.text = user.email
            phoneNumberTextLabel.text = user.mobile
            companyNameText.text = user.company_name
            
            // Safely unwrap optional address components
            let fullAddress = [user.address1, user.address2, user.city, user.country, user.postcode]
                .compactMap { $0 } // Filter out nil values
                .joined(separator: ", ")
            companyLAbelTextLAbel.text = fullAddress
        }

        // MARK: - Loading Indicator
        func showLoadingIndicator() {
            loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loadingIndicator)

            NSLayoutConstraint.activate([
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])

            loadingIndicator.startAnimating()
        }

        func hideLoadingIndicator() {
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }

        // MARK: - CustomNavBarDelegate
        func didTapBackButton() {
            navigationController?.popViewController(animated: true)
        }
    
    private func loadUserFromDefaults() -> User1? {
        guard let userData = UserDefaults.standard.data(forKey: "userData") else {
            return nil
        }
        do {
            return try JSONDecoder().decode(User1.self, from: userData)
        } catch {
            print("❌ Failed to decode user from UserDefaults:", error.localizedDescription)
            return nil
        }
    }
    }
