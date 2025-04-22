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
    static func createTextField(placeholder: String, isSecure: Bool = false, leftImage: String? = nil) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name: "Roboto-Regular", size: 14)
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.isSecureTextEntry = isSecure
        textField.leftViewMode = .always

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
    
    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        return label
    }
}
