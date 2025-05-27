//
//  ExpandableCell.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 13/05/25.
//

import Foundation
import UIKit

class ExpandableCell: UITableViewCell {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let offerLabelRed = PaddingLabel()
    let offerLabelGreen = PaddingLabel()

    let arrowImageView = UIImageView()
    let spacerView = UIView()
    
    private var titleWithIconConstraint: NSLayoutConstraint!
    private var titleWithoutIconConstraint: NSLayoutConstraint!
    private var loadedIcon: UIImage? // To store the loaded icon
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    func setupViews() {
        backgroundColor = .customBlue
        
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 10
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.black.cgColor
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        //  offrLabel.backgroundColor = .customRed
//        offrLabel.textColor = .systemGray5
//        offrLabel.font = UIFont(name: "Roboto-Bold", size: 12)
//        offrLabel.textAlignment = .center
//        offrLabel.layer.cornerRadius = 10
//        offrLabel.clipsToBounds = true
//        offrLabel.translatesAutoresizingMaskIntoConstraints = false
//        offrLabel.isHidden = true
//        offrLabel.setContentHuggingPriority(.required, for: .horizontal)
//        contentView.addSubview(offrLabel)
        
        for label in [offerLabelRed, offerLabelGreen] {
            label.textColor = .white
            label.font = UIFont(name: "Roboto-Bold", size: 12)
            label.textAlignment = .center
            label.layer.cornerRadius = 10
            label.clipsToBounds = true
            label.translatesAutoresizingMaskIntoConstraints = false
            label.setContentHuggingPriority(.required, for: .horizontal)
            contentView.addSubview(label)
            label.isHidden = true
        }

        
        arrowImageView.image = UIImage(systemName: "chevron.down")
        arrowImageView.tintColor = .white
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(arrowImageView)
        
        spacerView.backgroundColor = .white
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spacerView)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            iconImageView.widthAnchor.constraint(equalToConstant: 50),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            
            offerLabelRed.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            offerLabelRed.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            offerLabelRed.heightAnchor.constraint(equalToConstant: 30),
            
            offerLabelGreen.leadingAnchor.constraint(equalTo: offerLabelRed.trailingAnchor, constant: 6),
            offerLabelGreen.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            offerLabelGreen.heightAnchor.constraint(equalToConstant: 30),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            
            spacerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spacerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            spacerView.heightAnchor.constraint(equalToConstant: 5),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 55)
        ])
        
        // Title label constraints (managed dynamically)
        titleWithIconConstraint = titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20)
        titleWithoutIconConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        
        // Default state
        titleWithIconConstraint.isActive = true
    }
    
    func configure(title: String, imageUrl: String?, isExpanded: Bool, isSubCell: Bool = false, offerName: String, isCategoryCell: Bool = false) {
        titleLabel.text = title
        
        UIView.animate(withDuration: 0.25) {
               self.arrowImageView.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi * 2 ) : .identity
           }
        
        // Highest priority: DEALS & OFFERS cell
        if !isSubCell && title.uppercased() == "DEALS & OFFERS" {
            backgroundColor = .customRed
            titleLabel.textColor = .white
            arrowImageView.tintColor = .white
            iconImageView.tintColor = .white
        }
        // Next priority: Category cell
        else if isCategoryCell {
            backgroundColor = .customGray
            titleLabel.textColor = .customRed
            arrowImageView.tintColor = .customRed
            iconImageView.tintColor = .white
        }
        // Default styling
        else {
            backgroundColor = isSubCell ? .customGray : .customBlue
            titleLabel.textColor = isSubCell ? .black : .white
            arrowImageView.tintColor = isSubCell ? .black : .white
            iconImageView.tintColor = isSubCell ? .black : .white
        }
        
        offerLabelRed.isHidden = true
        offerLabelGreen.isHidden = true

        let trimmedOffer = offerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let offers = trimmedOffer.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

        if offers.count == 1 {
            // Single offer → use red
            offerLabelRed.text = offers[0].capitalized
            offerLabelRed.backgroundColor = .customRed
            offerLabelRed.isHidden = false
        } else if offers.count >= 2 {
            // Two offers → red and green
            offerLabelRed.text = offers[0].capitalized
            offerLabelRed.backgroundColor = .customRed
            offerLabelRed.isHidden = false

            offerLabelGreen.text = offers[1].capitalized
            offerLabelGreen.backgroundColor = UIColor(hex:"#008000")
            offerLabelGreen.isHidden = false
        }
        
        // Image logic
        if isSubCell {
            iconImageView.isHidden = false
            titleWithIconConstraint.isActive = true
            titleWithoutIconConstraint.isActive = false
            
            if let urlString = imageUrl, let url = URL(string: urlString) {
                iconImageView.load(url: url)
            } else {
                iconImageView.image = UIImage(named: "noImage")
            }
        } else {
            iconImageView.image = nil
            iconImageView.isHidden = true
            titleWithIconConstraint.isActive = false
            titleWithoutIconConstraint.isActive = true
        }
        
        // Arrow icon direction
        arrowImageView.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
    }
}


class PaddingLabel: UILabel {

    var topInset: CGFloat = 4
    var bottomInset: CGFloat = 4
    var leftInset: CGFloat = 8
    var rightInset: CGFloat = 8

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
