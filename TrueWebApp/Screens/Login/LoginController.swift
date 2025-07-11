//
//  LoginController.swift
//  TrueApp
//
//  Created by Umang Kedan on 07/02/25.
//

import UIKit

enum AuthSegment: Int {
    case login = 0
    case register = 1
}

class LoginController: UIViewController, UITextViewDelegate {
    private var stackView = UIStackView()
    private var hstack = UIStackView()
    private var hstack2 = UIStackView()
    private var estack = UIStackView()
    private var estack2 = UIStackView()
    
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var logoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LOGIN", "REGISTER"])
        control.selectedSegmentIndex = 0
        control.selectedSegmentTintColor = .customBlue
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
            .font: UIFont(name: "Roboto-Bold", size: 14) ?? "" ]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Roboto-Bold", size: 14) ?? "" ]
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        return control
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.heightAnchor.constraint(equalToConstant: 0.8).isActive = true
        return view
    }()
    
    private let forgotLabel : UILabel = {
        let label = UILabel()
        label.text = "Forgot Passoword?"
        label.textColor = .customBlue
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textAlignment = .right
        label.text = "Forgot Password?"
        return label
    }()
    
    private let emailErrorLabel = HelperFunct.createErrorLabel()
    private let passwordErrorLabel = HelperFunct.createErrorLabel()
    private let firstNameErrorLabel = HelperFunct.createErrorLabel()
    private let lastNameErrorLabel = HelperFunct.createErrorLabel()
    private let mobileErrorLabel = HelperFunct.createErrorLabel()
    private let companyErrorLabel = HelperFunct.createErrorLabel()
    private let address1ErrorLabel = HelperFunct.createErrorLabel()
    private let cityErrorLabel = HelperFunct.createErrorLabel()
    private let countryErrorLabel = HelperFunct.createErrorLabel()
    private let postcodeErrorLabel = HelperFunct.createErrorLabel()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var isLogin = true
    
    private let username = HelperFunct.createTextField(placeholder: "First Name", leftImage: "user_fill")
    private let userLastName = HelperFunct.createTextField(placeholder: "Last Name", leftImage: "user_fill")
    private let companyNameField = HelperFunct.createTextField(placeholder: "Company name", leftImage: "company")
    private let invoiceAddressLine1Field = HelperFunct.createTextField(placeholder: "Address Line 1", leftImage: "location")
    private let invoiceAddressLine2Field = HelperFunct.createTextField(placeholder: "Address Line 2", leftImage: "location")
    private let invoiceAddressCityField = HelperFunct.createTextField(placeholder: "City", leftImage: "location")
    private let invoiceAddressCountyField = HelperFunct.createTextField(placeholder: "County", leftImage: "location")
    private let invoiceAddressPostcodeField = HelperFunct.createTextField(placeholder: "Postcode", leftImage: "location")
    private let mobileNumberField = HelperFunct.createTextField(placeholder: "Mobile number", leftImage: "call")
    private let emailField = HelperFunct.createTextField(placeholder: "Email", leftImage: "email")
    private let passwordField = HelperFunct.createPasswordField(placeholder: "Password", leftImage: "lock")
    private let repCodeField = HelperFunct.createTextField(placeholder: "Rep code", leftImage: "rep")
    
    private let termsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .center
        textView.dataDetectorTypes = []
        textView.isUserInteractionEnabled = true
        return textView
    }()
    
    var buttonHeightConstraint: NSLayoutConstraint!
    
    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        button.backgroundColor = .customRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var authButtonHeightConstraint: NSLayoutConstraint!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIForSegment()
        setupTermsText(isLogin: isLogin)
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        
        forgotLabel.isUserInteractionEnabled = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(forgotLabelTapped))
        forgotLabel.addGestureRecognizer(tapGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - UI Setup
    
    private func setupTermsText(isLogin : Bool) {
        let text = "By selecting \(isLogin == true ? "Login" : "Register"), you agree to our Terms and Conditions and Privacy Policy."
        let attributedText = NSMutableAttributedString(string: text)

        let termsRange = (text as NSString).range(of: "Terms and Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")

        attributedText.addAttribute(.link, value: "app://terms", range: termsRange)
        attributedText.addAttribute(.link, value: "app://privacy", range: privacyRange)
        attributedText.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: text.count))

        termsTextView.attributedText = attributedText
        termsTextView.linkTextAttributes = [
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        termsTextView.delegate = self
        termsTextView.textAlignment = .center
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)

        navigationController?.navigationBar.isHidden = true
        scrollView.addSubview(contentView)

        authButtonHeightConstraint = authButton.heightAnchor.constraint(equalToConstant: 50)
        authButtonHeightConstraint.isActive = true

        hstack = UIStackView(arrangedSubviews: [username, userLastName])
        hstack.axis = .horizontal
        hstack.spacing = 16
        hstack.distribution = .fillEqually

        estack = UIStackView(arrangedSubviews: [firstNameErrorLabel, lastNameErrorLabel])
        estack.axis = .horizontal
        estack.spacing = 16
        estack.distribution = .fillEqually

        estack2 = UIStackView(arrangedSubviews: [cityErrorLabel, postcodeErrorLabel])
        estack2.axis = .horizontal
        estack2.spacing = 16
        estack2.distribution = .fillEqually

        hstack2 = UIStackView(arrangedSubviews: [invoiceAddressCityField, invoiceAddressPostcodeField])
        hstack2.axis = .horizontal
        hstack2.spacing = 16
        hstack2.distribution = .fillEqually

        stackView = UIStackView(arrangedSubviews: [
            hstack, estack, mobileNumberField, mobileErrorLabel, emailField, emailErrorLabel, passwordField, passwordErrorLabel,forgotLabel,
            repCodeField, companyNameField, companyErrorLabel, invoiceAddressLine1Field, address1ErrorLabel,
            invoiceAddressLine2Field, hstack2, estack2, invoiceAddressCountyField, countryErrorLabel, authButton, termsTextView
        ])

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .fill
        contentView.addSubview(stackView)

        [logoImageView, segmentedControl, scrollView, contentView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            logoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: 70),

            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 50),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),

            segmentedControl.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),

            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func forgotLabelTapped() {
        let forgetVC = ForgetPasswordViewController()
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.pushViewController(forgetVC, animated: true)
    }

    // MARK: - Segmented Control Action
    @objc private func segmentChanged() {
        updateUIForSegment()
    }
    
    private func updateUIForSegment() {
        let isLogin = segmentedControl.selectedSegmentIndex == AuthSegment.login.rawValue
        setupTermsText(isLogin: isLogin)
        authButton.setTitle(isLogin ? "LOGIN" : "REGISTER", for: .normal)

        // Adjust spacing
        stackView.spacing = isLogin ? 16 : 8  // Example: 16 for login, 8 for register

        UIView.performWithoutAnimation {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

            if isLogin {
                stackView.addArrangedSubview(emailField)
                stackView.addArrangedSubview(emailErrorLabel)
                stackView.addArrangedSubview(passwordField)
                stackView.addArrangedSubview(passwordErrorLabel)
                stackView.addArrangedSubview(forgotLabel)
            } else {
                stackView.addArrangedSubview(hstack)
                stackView.addArrangedSubview(estack)
                stackView.addArrangedSubview(mobileNumberField)
                stackView.addArrangedSubview(mobileErrorLabel)
                stackView.addArrangedSubview(emailField)
                stackView.addArrangedSubview(emailErrorLabel)
                stackView.addArrangedSubview(passwordField)
                stackView.addArrangedSubview(passwordErrorLabel)
                stackView.addArrangedSubview(repCodeField)
                stackView.addArrangedSubview(companyNameField)
                stackView.addArrangedSubview(companyErrorLabel)
                stackView.addArrangedSubview(invoiceAddressLine1Field)
                stackView.addArrangedSubview(address1ErrorLabel)
                stackView.addArrangedSubview(invoiceAddressLine2Field)
                stackView.addArrangedSubview(hstack2)
                stackView.addArrangedSubview(estack2)
                stackView.addArrangedSubview(invoiceAddressCountyField)
                stackView.addArrangedSubview(countryErrorLabel)
            }

            stackView.addArrangedSubview(authButton)
            stackView.addArrangedSubview(termsTextView)
            stackView.layoutIfNeeded()
        }
    }

    // MARK: - Button Action
    @objc private func authButtonTapped() {
        if segmentedControl.selectedSegmentIndex == AuthSegment.login.rawValue {
                // Login Validation
                guard validateLoginFields() else { return }

                let loginModel = LogInModel(email: emailField.text ?? "", password: passwordField.text ?? "")
                ApiService.shared.loginUser(with: loginModel, from: self) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(_):
                            self.clearAllFields()
                            let mainTabBarController = TabBarController(nibName: "TabBarController", bundle: nil)
                            self.navigationController?.pushViewController(mainTabBarController, animated: true)
                            self.navigationController?.setNavigationBarHidden(true, animated: true)

                        case .failure(let error):
                            print("Login error: \(error.localizedDescription)")
                            ApiService().showAlert(message: error.localizedDescription, from: self)
                        }
                    }
                }
            }
         else {
            // Registration Validation
            guard validateRegisterFields() else { return }

            let registerModel = RegisterModel(
                first_name: username.text ?? "",
                last_name: userLastName.text ?? "",
                email: emailField.text ?? "",
                password: passwordField.text ?? "",
                mobile: mobileNumberField.text ?? "",
                rep_code: repCodeField.text ?? "",
                company_name: companyNameField.text ?? "",
                address1: invoiceAddressLine1Field.text ?? "",
                address2: invoiceAddressLine2Field.text ?? "",
                city: invoiceAddressCityField.text ?? "",
                country: invoiceAddressCountyField.text ?? "",
                postcode: invoiceAddressPostcodeField.text ?? ""
            )

            ApiService.shared.registerUser(with: registerModel) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let message):
                        HelperFunct().showAlert(view: self, title: "Success", message: message)
                    case .failure(let error):
                        HelperFunct().showAlert(view: self ,title: "Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
    func validateLoginFields() -> Bool {
        var isValid = true
        
        // Validate Password
        if let password = passwordField.text, password.isEmpty {
            passwordErrorLabel.text = "Password is required"
            passwordErrorLabel.isHidden = false
            isValid = false
        } else if let password = passwordField.text, password.count < 8 {
            passwordErrorLabel.text = "Password should be at least 8 characters long"
            passwordErrorLabel.isHidden = false
            isValid = false
        } else {
            passwordErrorLabel.isHidden = true
        }

        // Validate Email
        if let email = emailField.text, email.count == 0 {
            emailErrorLabel.text = "Email is required"
            emailErrorLabel.isHidden = false
        } else
        if let email = emailField.text, !isValidEmail(email) {
            emailErrorLabel.text = "Invalid email format"
            emailErrorLabel.isHidden = false
            isValid = false
        } else {
            emailErrorLabel.isHidden = true
        }

        return isValid
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }


    private func validateRegisterFields() -> Bool {
        var isValid = true
        [firstNameErrorLabel, lastNameErrorLabel, emailErrorLabel, passwordErrorLabel, mobileErrorLabel,
         companyErrorLabel, address1ErrorLabel, cityErrorLabel, countryErrorLabel, postcodeErrorLabel].forEach {
            $0.isHidden = true
        }

        if username.text?.isEmpty ?? true {
            firstNameErrorLabel.text = "First name is required"
            firstNameErrorLabel.isHidden = false
            isValid = false
        }

        if userLastName.text?.isEmpty ?? true {
            lastNameErrorLabel.text = "Last name is required"
            lastNameErrorLabel.isHidden = false
            isValid = false
        }

        if emailField.text?.isEmpty ?? true {
            emailErrorLabel.text = "Email is required"
            emailErrorLabel.isHidden = false
            isValid = false
        }

        if let password = passwordField.text, password.count < 8 {
            passwordErrorLabel.text = "Password must be at least 8 characters"
            passwordErrorLabel.isHidden = false
            isValid = false
        }

        if mobileNumberField.text?.isEmpty ?? true {
            mobileErrorLabel.text = "Mobile number is required"
            mobileErrorLabel.isHidden = false
            isValid = false
        }

        if companyNameField.text?.isEmpty ?? true {
            companyErrorLabel.text = "Company name is required"
            companyErrorLabel.isHidden = false
            isValid = false
        }

        if invoiceAddressLine1Field.text?.isEmpty ?? true {
            address1ErrorLabel.text = "Address Line 1 is required"
            address1ErrorLabel.isHidden = false
            isValid = false
        }

        if invoiceAddressCityField.text?.isEmpty ?? true {
            cityErrorLabel.text = "City is required"
            cityErrorLabel.isHidden = false
            isValid = false
        }

        if invoiceAddressCountyField.text?.isEmpty ?? true {
            countryErrorLabel.text = "Country is required"
            countryErrorLabel.isHidden = false
            isValid = false
        }

        if invoiceAddressPostcodeField.text?.isEmpty ?? true {
            postcodeErrorLabel.text = "Postcode is required"
            postcodeErrorLabel.isHidden = false
            isValid = false
        }

        return isValid
    }
    
    private func clearAllFields() {
        emailField.text = ""
        passwordField.text = ""
        username.text = ""
        userLastName.text = ""
        mobileNumberField.text = ""
        repCodeField.text = ""
        companyNameField.text = ""
        invoiceAddressLine1Field.text = ""
        invoiceAddressLine2Field.text = ""
        invoiceAddressCityField.text = ""
        invoiceAddressCountyField.text = ""
        invoiceAddressPostcodeField.text = ""
    }


func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "app://terms" {
            let vc = HTMLPageViewController()
            vc.pageType = .terms // or .terms
            navigationController?.pushViewController(vc, animated: true)
        } else if URL.absoluteString == "app://privacy" {
            let vc = HTMLPageViewController()
            vc.pageType = .privacy // or .terms
            navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
}
