//
//  PasswordController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class PasswordController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    

    let bannerImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "bnr1")
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            return imageView
        }()
        
        let currentPasswordField = CustomPasswordField(placeholder: "Current Password")
        let newPasswordField = CustomPasswordField(placeholder: "New Password")
        let confirmPasswordField = CustomPasswordField(placeholder: "Confirm Password")
        
        let updateButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("UPDATE PASSWORD", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
            button.backgroundColor = UIColor.customRed
            button.layer.cornerRadius = 4
            button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(updatePasswordTapped), for: .touchUpInside)
            return button
        }()
        
        // MARK: - View Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            setupUI()
            setnavBar()
        }
        
        // MARK: - UI Setup
        func setupUI() {
            view.addSubview(bannerImageView)
            view.addSubview(currentPasswordField)
            view.addSubview(newPasswordField)
            view.addSubview(confirmPasswordField)
            view.addSubview(updateButton)
            
            setnavBar()
            
            // Enable Auto Layout
            bannerImageView.translatesAutoresizingMaskIntoConstraints = false
            currentPasswordField.translatesAutoresizingMaskIntoConstraints = false
            newPasswordField.translatesAutoresizingMaskIntoConstraints = false
            confirmPasswordField.translatesAutoresizingMaskIntoConstraints = false
            updateButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Banner Image Constraints
                bannerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor , constant: 60),
                bannerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bannerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bannerImageView.heightAnchor.constraint(equalToConstant: 120),
                
                // Current Password Field
                currentPasswordField.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
                currentPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                currentPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                currentPasswordField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                
                // New Password Field
                newPasswordField.topAnchor.constraint(equalTo: currentPasswordField.bottomAnchor, constant: 10),
                newPasswordField.leadingAnchor.constraint(equalTo: currentPasswordField.leadingAnchor),
                newPasswordField.trailingAnchor.constraint(equalTo: currentPasswordField.trailingAnchor),
                newPasswordField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                
                // Confirm Password Field
                confirmPasswordField.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 10),
                confirmPasswordField.leadingAnchor.constraint(equalTo: newPasswordField.leadingAnchor),
                confirmPasswordField.trailingAnchor.constraint(equalTo: newPasswordField.trailingAnchor),
                confirmPasswordField.heightAnchor.constraint(equalToConstant: textFieldHeight),
                
                // Update Button
                updateButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 20),
                updateButton.leadingAnchor.constraint(equalTo: confirmPasswordField.leadingAnchor),
                updateButton.trailingAnchor.constraint(equalTo: confirmPasswordField.trailingAnchor),
                updateButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Change Password")
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
        
        // MARK: - Button Action
        @objc func updatePasswordTapped() {
            print("Update Password Button Tapped")
        }
    }


