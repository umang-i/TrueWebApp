//
//  ProfileController.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ProfileController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavBar()
        
        emailLabelText.font = UIFont(name: "Roboto-Bold", size: 16)
        emailTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        repCodeLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        repcodeTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        companyLAbelTextLAbel.font = UIFont(name: "Roboto-Medium", size: 14)
        phoneNumberLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        companyNameText.font = UIFont(name: "Roboto-Medium", size: 14)
        companyNameLAbel.font = UIFont(name: "Roboto-Bold", size: 16)
        companyAddressLAbel.font = UIFont(name: "Roboto-Bold", size: 16)
        phoneNumberTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
        usernameLabel.font = UIFont(name: "Roboto-Bold", size: 20)

    }
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Profile")
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

}
