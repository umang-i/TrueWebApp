//
//  ForgotPasswordController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 27/06/25.
//

import UIKit

class ForgetPasswordViewController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private var topBackgroundView: UIView!
    private var navBar: CustomNavBar!

    // Use your custom text field helper
    private let emailField = HelperFunct.createTextField(placeholder: "Email", leftImage: "email")
    
    private let resendLabel: UILabel = {
        let label = UILabel()
        label.text = "Resend Code"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SEND", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        button.backgroundColor = .customRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your email address"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Forgot Password"
        setupNavBar()
        setupViews()
        setupNavBar()

        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    private func setupNavBar() {
        topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        navBar = CustomNavBar(text: "Forgot Password")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupViews() {
        emailField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(instructionLabel)
        view.addSubview(emailField)
        view.addSubview(sendButton)
        view.addSubview(resendLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: sendButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 30),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 8),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            
            resendLabel.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 20),
            resendLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func sendButtonTapped() {
        guard let email = emailField.text, !email.isEmpty else {
            HelperFunct().showAlert(view: self, title: "Error", message: "Please enter an email")
            return
        }

        // Start loader and disable button
        activityIndicator.startAnimating()
        sendButton.isEnabled = false
        sendButton.setTitle("", for: .normal)  // Optional: hide text while loading

        ApiService.shared.forgotPassword(email: email) { [weak self] success, message in
            DispatchQueue.main.async {
                guard let self = self else { return }

                // Stop loader and enable button
                self.activityIndicator.stopAnimating()
                self.sendButton.isEnabled = true
                self.sendButton.setTitle("SEND", for: .normal)

                HelperFunct().showAlert(view: self, title: success ? "Success" : "Error", message: message)
                self.resendLabel.isHidden = !success
            }
        }
    }
}
