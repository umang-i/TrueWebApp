//
//  PasswordController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class PasswordController: UIViewController, CustomNavBarDelegate {

    // MARK: - UI Components
    
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

    let currentPasswordHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Current password must match your existing one."
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    let newPasswordHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Use at least 8 characters including a number."
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

    let confirmPasswordHintLabel: UILabel = {
        let label = UILabel()
        label.text = "Must match the new password."
        label.font = UIFont(name: "Roboto-Regular", size: 12)
        label.textColor = .gray
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()

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

    let textFieldHeight: CGFloat = 40
    let buttonHeight: CGFloat = 44

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setnavBar()
    }

    // MARK: - Setup UI

    func setupUI() {
        view.addSubview(bannerImageView)
        view.addSubview(currentPasswordField)
        view.addSubview(currentPasswordHintLabel)
        view.addSubview(newPasswordField)
        view.addSubview(newPasswordHintLabel)
        view.addSubview(confirmPasswordField)
        view.addSubview(confirmPasswordHintLabel)
        view.addSubview(updateButton)

        // Enable Auto Layout
        [bannerImageView, currentPasswordField, currentPasswordHintLabel,
         newPasswordField, newPasswordHintLabel, confirmPasswordField,
         confirmPasswordHintLabel, updateButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            bannerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 120),

            currentPasswordField.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
            currentPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            currentPasswordField.heightAnchor.constraint(equalToConstant: 50),

            currentPasswordHintLabel.topAnchor.constraint(equalTo: currentPasswordField.bottomAnchor, constant: 2),
            currentPasswordHintLabel.leadingAnchor.constraint(equalTo: currentPasswordField.leadingAnchor),
            currentPasswordHintLabel.trailingAnchor.constraint(equalTo: currentPasswordField.trailingAnchor),

            newPasswordField.topAnchor.constraint(equalTo: currentPasswordHintLabel.bottomAnchor, constant: 10),
            newPasswordField.leadingAnchor.constraint(equalTo: currentPasswordField.leadingAnchor),
            newPasswordField.trailingAnchor.constraint(equalTo: currentPasswordField.trailingAnchor),
            newPasswordField.heightAnchor.constraint(equalToConstant: 50),

            newPasswordHintLabel.topAnchor.constraint(equalTo: newPasswordField.bottomAnchor, constant: 2),
            newPasswordHintLabel.leadingAnchor.constraint(equalTo: newPasswordField.leadingAnchor),
            newPasswordHintLabel.trailingAnchor.constraint(equalTo: newPasswordField.trailingAnchor),

            confirmPasswordField.topAnchor.constraint(equalTo: newPasswordHintLabel.bottomAnchor, constant: 10),
            confirmPasswordField.leadingAnchor.constraint(equalTo: newPasswordField.leadingAnchor),
            confirmPasswordField.trailingAnchor.constraint(equalTo: newPasswordField.trailingAnchor),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 50),

            confirmPasswordHintLabel.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 2),
            confirmPasswordHintLabel.leadingAnchor.constraint(equalTo: confirmPasswordField.leadingAnchor),
            confirmPasswordHintLabel.trailingAnchor.constraint(equalTo: confirmPasswordField.trailingAnchor),

            updateButton.topAnchor.constraint(equalTo: confirmPasswordHintLabel.bottomAnchor, constant: 20),
            updateButton.leadingAnchor.constraint(equalTo: confirmPasswordField.leadingAnchor),
            updateButton.trailingAnchor.constraint(equalTo: confirmPasswordField.trailingAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Navigation Bar

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

    // MARK: - Actions

    @objc func updatePasswordTapped() {
        print("Update Password Button Tapped")

        let currentPassword = currentPasswordField.text
        let newPassword = newPasswordField.text
        let confirmPassword = confirmPasswordField.text

        guard !currentPassword.isEmpty,
              !newPassword.isEmpty,
              !confirmPassword.isEmpty else {
            showAlert("All fields are required.", "Please fill in all fields.")
            return
        }

        guard currentPassword.count >= 8 else {
            showAlert("Invalid Current Password", "Current password must be at least 8 characters.")
            return
        }

        guard newPassword.count >= 8 else {
            showAlert("Invalid New Password", "New password must be at least 8 characters.")
            return
        }

        guard newPassword == confirmPassword else {
            showAlert("Passwords do not match.", "Please ensure the new password and confirmation match.")
            return
        }

        let passwordData = Password(
            current_password: currentPassword,
            new_password: newPassword,
            new_password_confirmation: confirmPassword
        )

        ApiService.shared.changePassword(passwordData) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    self.showAlert("Success", message)
                case .failure(let error):
                    self.showAlert("Error", error.localizedDescription)
                }
            }
        }
    }


    // MARK: - Alerts

    func showAlert(_ title: String = "Alert", _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
