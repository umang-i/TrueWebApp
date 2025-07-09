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
    
    private var shimmerContainer: UIView?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupNavBar()
            setupFonts()
            fetchUserData()
            showShimmerPlaceholders()
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
    
    private func showShimmerPlaceholders() {
        shimmerContainer = UIView()
        shimmerContainer?.translatesAutoresizingMaskIntoConstraints = false
        shimmerContainer?.isUserInteractionEnabled = false // ✅ Allow touches to pass through

        guard let shimmerContainer = shimmerContainer else { return }

        view.addSubview(shimmerContainer)
        view.bringSubviewToFront(shimmerContainer)

        NSLayoutConstraint.activate([
            shimmerContainer.topAnchor.constraint(equalTo: view.topAnchor),
            shimmerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shimmerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shimmerContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Hide real labels
        [usernameLabel, repcodeTextLabel, repCodeLabel, emailTextLabel, emailLabelText,
         phoneNumberTextLabel, phoneNumberLabel, companyLAbelTextLAbel,
         companyAddressLAbel, companyNameText, companyNameLAbel].forEach { $0?.isHidden = true }

        let targetLabels = [usernameLabel, repcodeTextLabel, emailTextLabel,
                            phoneNumberTextLabel, companyNameText, companyLAbelTextLAbel]

        for label in targetLabels {
            guard let label = label else { continue }
            let shimmer = ShimmerView()
            shimmer.translatesAutoresizingMaskIntoConstraints = false
            shimmer.layer.cornerRadius = 6
            shimmer.clipsToBounds = true
            shimmerContainer.addSubview(shimmer)

            NSLayoutConstraint.activate([
                shimmer.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                shimmer.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                shimmer.topAnchor.constraint(equalTo: label.topAnchor),
                shimmer.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ])
        }
    }

    private func hideShimmerPlaceholders() {
        shimmerContainer?.removeFromSuperview()
        shimmerContainer = nil

        // Show real content
        [usernameLabel, repcodeTextLabel, repCodeLabel, emailTextLabel, emailLabelText,
         phoneNumberTextLabel, phoneNumberLabel, companyLAbelTextLAbel,
         companyAddressLAbel, companyNameText, companyNameLAbel].forEach { $0?.isHidden = false }
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
        ApiService.shared.fetchUserProfile { profile in
            DispatchQueue.main.async {
                if let profile = profile {
                    print("✅ User name: \(profile.user_detail.name)")
                    self.hideShimmerPlaceholders()
                    self.updateUI(with: profile.user_detail)
                } else {
                    print("❌ Failed to load user profile.")
                }
            }
        }
    }

        // MARK: - Update UI
        func updateUI(with user: UserDetail) {
            usernameLabel.text = user.name
            repcodeTextLabel.text = "\(user.rep_id ?? 0 )"
            emailTextLabel.text = user.email
            phoneNumberTextLabel.text = user.mobile
            companyNameText.text = user.company_name
            
            // Safely unwrap optional address components
            let fullAddress = [user.address1, user.address2, user.city, user.country, user.postcode]
                .compactMap { $0 } // Filter out nil values
                .joined(separator: ", ")
            companyLAbelTextLAbel.text = fullAddress
        }

        // MARK: - CustomNavBarDelegate
        func didTapBackButton() {
            navigationController?.popViewController(animated: true)
        }
    
//    private func loadUserFromDefaults() -> UserDetails? {
//        guard let userData = UserDefaults.standard.data(forKey: "userData") else {
//            return nil
//        }
//        do {
//            return try JSONDecoder().decode(UserDetails.self, from: userData)
//        } catch {
//            print("❌ Failed to decode user from UserDefaults:", error.localizedDescription)
//            return nil
//        }
//    }
    }
