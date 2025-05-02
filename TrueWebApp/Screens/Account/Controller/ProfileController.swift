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
           usernameLabel.font = UIFont(name: "Roboto-Bold", size: 20)
           repCodeLabel.font = UIFont(name: "Roboto-Bold", size: 16)
           repcodeTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
           emailLabelText.font = UIFont(name: "Roboto-Bold", size: 16)
           emailTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
           phoneNumberLabel.font = UIFont(name: "Roboto-Bold", size: 16)
           phoneNumberTextLabel.font = UIFont(name: "Roboto-Medium", size: 14)
           companyNameLAbel.font = UIFont(name: "Roboto-Bold", size: 16)
           companyNameText.font = UIFont(name: "Roboto-Medium", size: 14)
           companyAddressLAbel.font = UIFont(name: "Roboto-Bold", size: 16)
           companyLAbelTextLAbel.font = UIFont(name: "Roboto-Medium", size: 14)
       }

       // MARK: - Fetch User Data
       func fetchUserData() {
           AuthService.shared.fetchUserProfile { result in
               DispatchQueue.main.async {
                   switch result {
                   case .success(let user):
                       self.updateUI(with: user)
                   case .failure(let error):
                       print("Failed to fetch profile:", error.localizedDescription)
                   }
               }
           }
       }

       // MARK: - Update UI
       func updateUI(with user: User) {
           usernameLabel.text = user.name
           repcodeTextLabel.text = user.rep_code
           emailTextLabel.text = user.email
           phoneNumberTextLabel.text = user.mobile
           companyNameText.text = user.company_name
           companyLAbelTextLAbel.text = "\(user.address1), \(user.address2), \(user.city), \(user.country), \(user.postcode)"
       }

       // MARK: - CustomNavBarDelegate
       func didTapBackButton() {
           navigationController?.popViewController(animated: true)
       }
   }
