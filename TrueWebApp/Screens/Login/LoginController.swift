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
    
    // MARK: - UI Elements
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var logoContainerView : UIView = {
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
            .font: UIFont(name: "Roboto-Bold", size: 14) ,
            ]
        
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Roboto-Bold", size: 14)
        ]
        
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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    var isLogin = true
    
    private let username = HelperFunct.createTextField(placeholder: "First Name" , leftImage: "user_fill")
    private let userLastName = HelperFunct.createTextField(placeholder: "Last Name" , leftImage: "user_fill")
    
    private let companyNameField = HelperFunct.createTextField(placeholder: "Company name" , leftImage: "company")
    
   // private let invoiceAddressLabel = HelperFunct.createLabel(text: "Invoice Address")
    private let invoiceAddressLine1Field = HelperFunct.createTextField(placeholder: "Address Line 1" , leftImage: "location")
    private let invoiceAddressLine2Field = HelperFunct.createTextField(placeholder: "Address Line 2" , leftImage: "location")
    private let invoiceAddressCityField = HelperFunct.createTextField(placeholder: "City", leftImage: "location")
    private let invoiceAddressCountyField = HelperFunct.createTextField(placeholder: "County", leftImage: "location")
    private let invoiceAddressPostcodeField = HelperFunct.createTextField(placeholder: "Postcode", leftImage: "location")
    
   // private let mobileNumberLabel = HelperFunct.createLabel(text: "Mobile Number" )
    private let mobileNumberField = HelperFunct.createTextField(placeholder: "Mobile number" , leftImage: "call")
    
   // private let loginDetailsLabel = HelperFunct.createLabel(text: "Login Details")
    private let emailField = HelperFunct.createTextField(placeholder: "Email " , leftImage: "email")
    private let passwordField = HelperFunct.createTextField(placeholder: "Password", isSecure: true , leftImage: "lock")
    private let confirmPasswordField = HelperFunct.createTextField(placeholder: "Re-enter your password", isSecure: true, leftImage: "lock")
    private let repCodeField = HelperFunct.createTextField(placeholder: "Rep code" , leftImage: "rep")
    var buttonHeightConstraint: NSLayoutConstraint!
    
    
    private let authButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        button.backgroundColor = .customRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var authButtonHeightConstraint: NSLayoutConstraint!
    
    
    private let termsLabel: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .clear
        textView.textAlignment = .center  // Center align text
        
        // Ensure text is properly centered with padding removed
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0

        return textView
    }()

    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIForSegment()
        termsLabel.delegate = self
        authButton.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
    }

    // Override this in your ViewController to control status bar text color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // Makes time and battery icons white for visibility on blue background
    }

    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(logoContainerView)
        logoContainerView.addSubview(logoImageView)
        view.addSubview(segmentedControl)
        view.addSubview(scrollView)
        
        navigationController?.navigationBar.isHidden = true
        
        scrollView.addSubview(contentView)
        
        let smallSpacer = UIView()
        smallSpacer.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        authButtonHeightConstraint = authButton.heightAnchor.constraint(equalToConstant: 50)
        authButtonHeightConstraint.isActive = true
        
        hstack = UIStackView(arrangedSubviews: [username, userLastName])
        hstack.axis = .horizontal
        hstack.spacing = 16 // You can adjust the spacing as per design
        hstack.distribution = .fillEqually // This ensures both fields take equal space

        hstack2 = UIStackView(arrangedSubviews: [invoiceAddressCityField, invoiceAddressPostcodeField])
        hstack2.axis = .horizontal
        hstack2.spacing = 16 // You can adjust the spacing as per design
        hstack2.distribution = .fillEqually
        
        stackView = UIStackView(arrangedSubviews: [
            hstack,
            mobileNumberField,
            emailField,
            passwordField,
            repCodeField,
            companyNameField,
            invoiceAddressLine1Field,
            invoiceAddressLine2Field,
            hstack2,
            invoiceAddressCountyField,
          //  confirmPasswordField,
            smallSpacer,
            authButton,
            termsLabel
        ])

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .fill

        stackView.setCustomSpacing(20, after: confirmPasswordField)
        stackView.setCustomSpacing(20, after: mobileNumberField)
        
        contentView.addSubview(stackView)
        
        // Enable Auto Layout
        [logoImageView, segmentedControl, scrollView, contentView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            
            logoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            logoContainerView.heightAnchor.constraint(equalToConstant: 70), // Adjust height as needed
            
            // Adjusted logo position inside the container
            logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor), // Center vertically in the container
            logoImageView.heightAnchor.constraint(equalToConstant: 50), // Adjust size
            logoImageView.widthAnchor.constraint(equalToConstant: 100) ,
            
            // Segmented Control
            segmentedControl.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View inside ScrollView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // StackView inside Content View
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Segmented Control Action
    @objc private func segmentChanged() {
        updateUIForSegment()
    }
    
    private func updateUIForSegment() {
        let isLogin = segmentedControl.selectedSegmentIndex == AuthSegment.login.rawValue
        hstack.isHidden = isLogin
        hstack2.isHidden = isLogin
        companyNameField.isHidden = isLogin
      //  invoiceAddressLabel.isHidden = isLogin
        invoiceAddressLine1Field.isHidden = isLogin
        invoiceAddressLine2Field.isHidden = isLogin
        invoiceAddressCityField.isHidden = isLogin
        invoiceAddressCountyField.isHidden = isLogin
        invoiceAddressPostcodeField.isHidden = isLogin
       // mobileNumberLabel.isHidden = isLogin
        mobileNumberField.isHidden = isLogin
        confirmPasswordField.isHidden = isLogin
        repCodeField.isHidden = isLogin
       // loginDetailsLabel.isHidden = isLogin

        authButton.setTitle(isLogin ? "LOGIN" : "REGISTER", for: .normal)
        authButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        authButtonHeightConstraint.constant = 50

        updateTermsLabel(isLogin: isLogin)
    }

    
    private func updateTermsLabel(isLogin: Bool) {
        let text = isLogin
        ? "By selecting Login, you agree to our Terms & Conditions and Privacy Policy."
        : "By selecting Register, you agree to our Terms & Conditions and Privacy Policy."
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let termsRange = (text as NSString).range(of: "Terms & Conditions")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(.link, value: "terms://", range: termsRange)
        attributedString.addAttribute(.link, value: "privacy://", range: privacyRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: termsRange)
        attributedString.addAttribute(.foregroundColor, value: UIColor.customLightBlue, range: privacyRange)
        
        termsLabel.attributedText = attributedString
        termsLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        termsLabel.textAlignment = .center
        termsLabel.linkTextAttributes = [
            .foregroundColor: UIColor.customLightBlue,
            .underlineStyle : NSUnderlineStyle.single.rawValue,
            .underlineColor : UIColor.customLightBlue
        ]
    }
    // MARK: - Button Action
    @objc private func authButtonTapped() {
        if segmentedControl.selectedSegmentIndex == AuthSegment.login.rawValue {
           
            let mainTabBarController = TabBarController(nibName: "TabBarController", bundle: nil)
            //DashboardController(nibName: "DashboardController", bundle: nil)
            navigationController?.pushViewController(mainTabBarController, animated: true)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            print("Login Pressed")
        } else {
            print("Register Pressed")
        }
    }
}


