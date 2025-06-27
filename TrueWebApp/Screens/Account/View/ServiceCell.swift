//
//  ServiceCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 21/02/25.
//

import UIKit

class ServiceCell: UITableViewCell {
    
    // UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    let posImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let featuresList: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        return stackView
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.customBlue.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        return textField
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register Interest", for: .normal)
        button.backgroundColor = .customRed
        button.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 13)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "PRODUCTS NOT INCLUDED - ADDITIONAL TERMS AND CONDITIONS APPLY"
        label.numberOfLines = 2
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.customBlue.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        [titleLabel, subtitleLabel, posImageView, featuresList, textField, registerButton, disclaimerLabel].forEach {
            containerView.addSubview($0)
        }
        
        // Auto Layout Constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        posImageView.translatesAutoresizingMaskIntoConstraints = false
        featuresList.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            posImageView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            posImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            posImageView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            posImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: 10),
            posImageView.heightAnchor.constraint(equalToConstant: 220),
            
            featuresList.topAnchor.constraint(equalTo: posImageView.bottomAnchor, constant: 16),
            featuresList.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            textField.topAnchor.constraint(equalTo: featuresList.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            registerButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            registerButton.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            registerButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            registerButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            disclaimerLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 8),
            disclaimerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            disclaimerLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            disclaimerLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configure Cell
    func configure(with solution: ServiceSolution) {
        titleLabel.text = solution.service_solution_title
        subtitleLabel.text = solution.service_solution_sub_title
        
        // Load image
        if let url = URL(string: "https://cdn.truewebpro.com/\(solution.service_solution_image)") {
            posImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        
        // Remove previous feature labels before adding new ones
        featuresList.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Convert description into feature list
        let features = solution.service_solution_desc
            .components(separatedBy: "\r\n")
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        for feature in features {
            let bulletView = UIView()
            bulletView.backgroundColor = .customBlue
            bulletView.layer.cornerRadius = 4
            bulletView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bulletView.widthAnchor.constraint(equalToConstant: 8),
                bulletView.heightAnchor.constraint(equalToConstant: 8)
            ])
            
            let featureLabel = UILabel()
            featureLabel.text = feature
            featureLabel.font = UIFont(name: "Roboto-Regular", size: 14)
            featureLabel.textColor = .black
            
            let featureStack = UIStackView(arrangedSubviews: [bulletView, featureLabel])
            featureStack.axis = .horizontal
            featureStack.spacing = 8
            featureStack.alignment = .center
            
            featuresList.addArrangedSubview(featureStack)
        }
    }
}
