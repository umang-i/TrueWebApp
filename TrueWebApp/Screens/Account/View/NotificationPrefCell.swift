//
//  NotificationPrefCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class NotificationPrefCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let enabledButton = UIButton(type: .system)
    private let disabledButton = UIButton(type: .system)
    private let enabledRadioView = UIView()
    private let disabledRadioView = UIView()
    private let enabledInnerView = UIView()
    private let disabledInnerView = UIView()
    private var toggleCallback: ((Bool) -> Void)?
    private let containerView = UIView()
    private var isEnabledSelected: Bool = true

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        
        // Style the container with border & rounded corners
        containerView.layer.cornerRadius = 4
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.customBlue.cgColor
        containerView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(containerView)
        
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)

        // Button setup
        enabledButton.setTitle("Enabled", for: .normal)
        disabledButton.setTitle("Disabled", for: .normal)
        enabledButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)
        disabledButton.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 14)

        enabledButton.setTitleColor(.customBlue, for: .normal)
        disabledButton.setTitleColor(.customRed, for: .normal)

        enabledButton.addTarget(self, action: #selector(enabledTapped), for: .touchUpInside)
        disabledButton.addTarget(self, action: #selector(disabledTapped), for: .touchUpInside)

        // Create radio buttons with inner circle
        setupRadioButton(outerView: enabledRadioView, innerView: enabledInnerView, selector: #selector(enabledTapped))
        setupRadioButton(outerView: disabledRadioView, innerView: disabledInnerView, selector: #selector(disabledTapped))

        let enabledStackView = UIStackView(arrangedSubviews: [enabledRadioView, enabledButton])
        let disabledStackView = UIStackView(arrangedSubviews: [disabledRadioView, disabledButton])

        enabledStackView.axis = .horizontal
        enabledStackView.spacing = 15

        disabledStackView.axis = .horizontal
        disabledStackView.spacing = 15

        let optionsStackView = UIStackView(arrangedSubviews: [enabledStackView, UIView(), disabledStackView])
        optionsStackView.axis = .horizontal
        optionsStackView.spacing = 30
        optionsStackView.alignment = .center
        optionsStackView.distribution = .fillEqually

        containerView.addSubview(optionsStackView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Title label outside container
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // ContainerView below title
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            optionsStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            optionsStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            optionsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with setting: NotificationSetting, toggleCallback: @escaping (Bool) -> Void) {
        titleLabel.text = setting.title
        self.toggleCallback = toggleCallback
        isEnabledSelected = setting.isEnabled
        updateUI()
    }

    private func updateUI() {
        DispatchQueue.main.async {
            // Update radio button colors
            self.enabledInnerView.backgroundColor = self.isEnabledSelected ? .customBlue : .clear
            self.disabledInnerView.backgroundColor = self.isEnabledSelected ? .clear : .customRed

            self.enabledRadioView.layer.borderColor = self.isEnabledSelected ? UIColor.customBlue.cgColor : UIColor.customBlue.cgColor
            self.disabledRadioView.layer.borderColor = self.isEnabledSelected ? UIColor.customBlue.cgColor : UIColor.customRed.cgColor
        }
    }

    @objc private func enabledTapped() {
        if !isEnabledSelected {
            isEnabledSelected = true
            toggleCallback?(true)
            updateUI()
        }
    }

    @objc private func disabledTapped() {
        if isEnabledSelected {
            isEnabledSelected = false
            toggleCallback?(false)
            updateUI()
        }
    }

    private func setupRadioButton(outerView: UIView, innerView: UIView, selector: Selector) {
        // Outer circle (border)
        outerView.layer.cornerRadius = 4
        outerView.layer.borderWidth = 2
        outerView.layer.borderColor = UIColor.customRed.cgColor
        outerView.backgroundColor = .white
        outerView.translatesAutoresizingMaskIntoConstraints = false
        outerView.isUserInteractionEnabled = true

        // Inner circle (filled when selected)
        innerView.layer.cornerRadius = 4
        innerView.backgroundColor = .clear
        innerView.translatesAutoresizingMaskIntoConstraints = false

        // Add tap gesture to outerView
        let tapGesture = UITapGestureRecognizer(target: self, action: selector)
        outerView.addGestureRecognizer(tapGesture)

        // Add innerView inside outerView
        outerView.addSubview(innerView)

        NSLayoutConstraint.activate([
            outerView.widthAnchor.constraint(equalToConstant: 24),
            outerView.heightAnchor.constraint(equalToConstant: 24),

            innerView.centerXAnchor.constraint(equalTo: outerView.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: outerView.centerYAnchor),
            innerView.widthAnchor.constraint(equalToConstant: 12),
            innerView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
