//
//  HelperFunct.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import Foundation
import UIKit

class HelperFunct {
    
    // MARK: - Helper Methods
    static func createTextField(placeholder: String, leftImage: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name: "Roboto-Regular", size: 14)
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none

        // Set placeholder text attributes
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)

        // Add left image if provided
        if let image = leftImage, let uiImage = UIImage(named: image)?.withRenderingMode(.alwaysTemplate) {
            let imageView = UIImageView(image: uiImage)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.customBlue
            imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

            let container = UIView(frame: CGRect(x: 3, y: 0, width: 36, height: 24))
            imageView.center = container.center
            container.addSubview(imageView)

            textField.leftView = container
        }

        return textField
    }

    static func createPasswordField(placeholder: String, leftImage: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name: "Roboto-Regular", size: 14)
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.isSecureTextEntry = true
        textField.leftViewMode = .always
        textField.rightViewMode = .always

        // Placeholder attributes
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)

        // Left image setup
        if let image = leftImage, let uiImage = UIImage(named: image)?.withRenderingMode(.alwaysTemplate) {
            let imageView = UIImageView(image: uiImage)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = UIColor.customBlue
            imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

            let container = UIView(frame: CGRect(x: 3, y: 0, width: 36, height: 24))
            imageView.center = container.center
            container.addSubview(imageView)

            textField.leftView = container
        }

        // Eye icon with 10pt trailing padding
        let eyeButton = UIButton(type: .custom)
        eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
        eyeButton.tintColor = .customBlue
        eyeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        eyeButton.addAction(UIAction { _ in
            textField.isSecureTextEntry.toggle()
            let newImageName = textField.isSecureTextEntry ? "eye" : "eye.slash"
            eyeButton.setImage(UIImage(systemName: newImageName), for: .normal)
        }, for: .touchUpInside)

        // Container view for padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        eyeButton.center = CGPoint(x: containerView.frame.width - 20, y: containerView.frame.height / 2)
        containerView.addSubview(eyeButton)

        textField.rightView = containerView

        return textField
    }


    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        return label
    }
    static func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
        label.isHidden = true
        
        return label
    }
    func showAlert(view : UIViewController , title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        view.present(alert, animated: true, completion: nil)
    }
    func makeFieldWithErrorStack(field: UITextField, errorLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [field, errorLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }
}
