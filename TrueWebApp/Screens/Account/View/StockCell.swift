//
//  StockCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class StockCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        selectionStyle = .none
        
        // Configure subtitle label
        subtitleLabel.text = "No products added!"
        subtitleLabel.textColor = .customBlue
        subtitleLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        subtitleLabel.textAlignment = .center

        // Create a stack view for the labels
        let stackView = UIStackView(arrangedSubviews: [subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading

        // Add stack view to the content view
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        // Add border and corner radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.customBlue.cgColor // Ensure `.customBlue` is defined in your project
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
    }

    /// Configure cell with dynamic subtitle
    func configure(subtitle: String) {
        subtitleLabel.text = subtitle
    }
}
