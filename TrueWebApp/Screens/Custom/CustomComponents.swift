//
//  CustomComponents.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import Foundation
import UIKit

var buttonHeight = 50.0
var textFieldHeight = 50.0

class CustomRadioButton: UIButton {
    
    // Selected and unselected states
    private let selectedColor: UIColor = .customRed
    private let unselectedColor: UIColor = .gray
    private let borderColor: UIColor = .customBlue
    private let circleSize: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        self.layer.cornerRadius = circleSize / 2
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = .white
    }
    
    func setSelected(_ isSelected: Bool) {
        self.backgroundColor = isSelected ? selectedColor : .white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}


class CustomPasswordField: UIView {

    private let textField: UITextField = {
        let tf = UITextField()
        tf.isSecureTextEntry = true
        tf.font = UIFont(name: "Roboto-Regular", size: 14)
        tf.borderStyle = .none
        tf.textColor = .black

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        tf.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)

        return tf
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.customBlue.cgColor
        return view
    }()

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "eye.slash") // hidden state
        button.setImage(image, for: .normal)
        button.tintColor = .customBlue
        return button
    }()

    // External view you want to toggle
    public weak var abstractViewToToggle: UIView?

    private var isPasswordVisible = false

    public var text: String {
        return textField.text ?? ""
    }

    init(placeholder: String) {
        super.init(frame: .zero)

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)

        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(toggleButton)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        toggleButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: toggleButton.leadingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            textField.heightAnchor.constraint(equalToConstant: 50),

            toggleButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            toggleButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            toggleButton.widthAnchor.constraint(equalToConstant: 24),
            toggleButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setupActions() {
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible

        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)

        // Toggle the abstractView's visibility (if assigned)
        abstractViewToToggle?.isHidden = !isPasswordVisible
    }
}


class CustomTextField: UITextField {

    init(placeholder: String, text: String? = nil) {
        super.init(frame: .zero)
        self.text = text
        setupTextField(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField(placeholder: "")
    }

    private func setupTextField(placeholder: String) {
        borderStyle = .roundedRect
        font = UIFont(name: "Roboto-Medium", size: 14)!
        textColor = .black
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = UIColor.customBlue.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
}


class CustomSectionLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.font = UIFont(name: "Roboto-Bold", size: 16)!
        self.textColor = .black
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func showLogoutAlert(on viewController: UIViewController) {
    let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
        logoutAndRedirectToLogin(from: viewController)
    }))
    
    viewController.present(alert, animated: true, completion: nil)
}

func logoutAndRedirectToLogin(from viewController: UIViewController) {
    // Clear all UserDefaults (or just the token if needed)
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "authToken") 
    defaults.synchronize()

    // Navigate to login screen
    let loginVC = LoginController()
    let navController = UINavigationController(rootViewController: loginVC)

    // Set as root view controller
    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
        sceneDelegate.window?.rootViewController = navController
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

func handleLogout() {
    ApiService.shared.deleteUserAccount { success, message in
        if success {
            print("✅ Account deleted: \(message ?? "")")
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "authToken")
            defaults.synchronize()

            // Navigate to login screen
            let loginVC = LoginController()
            let navController = UINavigationController(rootViewController: loginVC)

            // Set as root view controller
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        } else {
            print("❌ Failed to delete account: \(message ?? "Unknown error")")
        }
    }
}

func showDeleteAlert(on viewController: UIViewController) {
    let alertController = UIAlertController(title: "Delete Account",
                                            message: "Are you sure you want to delete your account?",
                                            preferredStyle: .alert)

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    let logoutAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
        handleLogout()
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(logoutAction)

    viewController.present(alertController, animated: true, completion: nil)
}

protocol CustomNavBarDelegate: AnyObject {
    func didTapBackButton()
}

class CustomNavBar: UIView {
    
    weak var delegate: CustomNavBarDelegate?

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white // Change color if needed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .customBlue
        button.setTitle(" Back", for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        button.contentHorizontalAlignment = .leading
        button.semanticContentAttribute = .forceLeftToRight
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customBlue
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(text: String) {
        super.init(frame: .zero)
        self.backgroundColor = .clear // Set clear to see backgroundView
        titleLabel.text = text

        // Add the background view to cover the entire top area
        addSubview(backgroundView)
        addSubview(backButton)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            // Background View Constraints (covering the top)
            backgroundView.topAnchor.constraint(equalTo: superview?.topAnchor ?? self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Back Button Constraints
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // Title Label Constraints
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        // Attach action for back button
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc private func backButtonTapped() {
        delegate?.didTapBackButton()
    }
}


extension UIColor {
    static let customBlue = UIColor(red: 3/255, green: 43/255, blue: 95/255, alpha: 1)
    static let customRed  = UIColor(red: 187/255, green: 0/255, blue: 0/255, alpha: 1)
    static let customLightBlue  = UIColor(red: 62/255, green: 169/255, blue: 245/255, alpha: 1)
    static let customGray = UIColor(hex: "#FDF6F6")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
