//
//  PaymentCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 25/03/25.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(arrowImageView)
        
        // Apply border and corner radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.customBlue.cgColor
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        
        // Constraints
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    func setCell(img: String, text: String, isArrow: Bool) {
        iconImageView.image = UIImage(named: img)
        nameLabel.text = text
        arrowImageView.isHidden = !isArrow
    }
}
