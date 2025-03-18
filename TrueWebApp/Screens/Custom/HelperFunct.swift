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
    static func createTextField(placeholder: String, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        textField.borderStyle = .roundedRect
        textField.font = UIFont(name: "Roboto-Regular", size: 14)
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.isSecureTextEntry = isSecure
        
        // Set placeholder text attributes
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray,
            .font: UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ]
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
        
        return textField
    }
    
    
    static func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Roboto-Bold", size: 14)
        return label
    }
}
