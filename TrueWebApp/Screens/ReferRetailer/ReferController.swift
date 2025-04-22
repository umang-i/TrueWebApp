//
//  ReferController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 18/03/25.
//

import Foundation
import UIKit

class ReferController : UIViewController , CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setnavBar()
    }
    
    func setupUI() {
        // ScrollView
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        // Content View inside ScrollView
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Banner Image
        let bannerImageView = UIImageView()
        bannerImageView.image = UIImage(named: "bnr1")
        bannerImageView.contentMode = .scaleToFill
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bannerImageView)
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = "Refer a Retailer"
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // Description Label
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Know a retailer that would benefit from using the Vape Supplier Trade App? Simply fill in the details below of the retailer you would like to refer and we'll get in touch and do the rest!"
        descriptionLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        let descriptionLabel1 = UILabel()
        descriptionLabel1.text = "Earn £10 credit straight to your wallet with every successful referral."
        descriptionLabel1.font = UIFont(name: "Roboto-Regular", size: 14)
        descriptionLabel1.numberOfLines = 0
        descriptionLabel1.textAlignment = .left
        descriptionLabel1.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel1)
        
        // Text Fields
        let nameTextField = CustomTextField(placeholder: "Enter referral's name...")
        let phoneTextField = CustomTextField(placeholder: "Enter referral's mobile phone number...")
        let locationTextField = CustomTextField(placeholder: "Enter referral's town / city...")
        
        contentView.addSubview(nameTextField)
        contentView.addSubview(phoneTextField)
        contentView.addSubview(locationTextField)
        
        // Send Referral Button
        let sendReferralButton = UIButton()
        sendReferralButton.setTitle(" Send Referral", for: .normal)
        sendReferralButton.backgroundColor = .customRed
        sendReferralButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        sendReferralButton.layer.cornerRadius = 4
        sendReferralButton.translatesAutoresizingMaskIntoConstraints = false
        sendReferralButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendReferralButton.tintColor = .white
        sendReferralButton.imageView?.contentMode = .scaleAspectFit
        sendReferralButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        contentView.addSubview(sendReferralButton)
        
        // Terms Label
        let termsLabel = UILabel()
        termsLabel.text = "Terms and Conditions Apply. Referral must transact on the Vape Supplier Trade app in order for you to be credited with your reward. If a retailer already has a live account on the platform the referral does not count. Referrals are for UK stores only."
        termsLabel.font = UIFont(name: "Roboto-Regular", size: 12)
        termsLabel.numberOfLines = 0
        termsLabel.textAlignment = .left
        termsLabel.textColor = .gray
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(termsLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            // ScrollView Constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View Constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Banner Image Constraints
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 120),

            // Title Label Constraints
            titleLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            // Description Labels Constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            descriptionLabel1.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionLabel1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            descriptionLabel1.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // TextField Constraints
            nameTextField.topAnchor.constraint(equalTo: descriptionLabel1.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            phoneTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            locationTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            locationTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            // Send Referral Button Constraints
            sendReferralButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 20),
            sendReferralButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            sendReferralButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            sendReferralButton.heightAnchor.constraint(equalToConstant: buttonHeight),

            // Terms Label Constraints
            termsLabel.topAnchor.constraint(equalTo: sendReferralButton.bottomAnchor, constant: 20),
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            termsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            termsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Ensures scrolling works properly
        ])
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Refer a Retailer")
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
