//
//  RewardCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/03/25.
//

import UIKit

import UIKit

struct RewardModel {
    let tierImage: UIImage?  // Tier icon
    let tierName: String     // e.g., Bronze, Silver, Gold
    let entryLevel: String   // e.g., "ENTRY"
    let description: String  // Tier description
    let bonusPoints: String  // Reward bonus points
    let freeShipping: String // Free shipping details
    let tierBonus: String    // Extra bonus points
}


class RewardCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let tierIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let tierLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        return label
    }()
    
    private let entryLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .systemGray4
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.text = "ENTRY"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let rewardBonusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let tierBonusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let claimButton : UIButton = {
        let button = UIButton()
        button.setTitle("CLAIM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customRed
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        return button
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        claimButton.addTarget(self, action: #selector(claimButtonTapped), for: .touchUpInside)

        // Set a fixed size for the icon
        tierIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tierIcon.widthAnchor.constraint(equalToConstant: 50),  // Adjust as needed
            tierIcon.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Prevent labels from being compressed
        tierLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        entryLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let mainStack = UIStackView(arrangedSubviews: [tierIcon, tierLabel, entryLabel])
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        mainStack.alignment = .center
        mainStack.distribution = .fill
        mainStack.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let detailsStack = UIStackView(arrangedSubviews: [rewardBonusLabel, freeShippingLabel, tierBonusLabel, claimButton])
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        detailsStack.alignment = .leading
        detailsStack.distribution = .fillEqually

        containerView.addSubview(mainStack)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(detailsStack)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: mainStack.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            detailsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            detailsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            detailsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            detailsStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            claimButton.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 20),
            claimButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            claimButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            claimButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            claimButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    @objc private func claimButtonTapped() {
        print("Claim button tapped!")
        // Perform action here (e.g., delegate callback, API request, etc.)
    }


    
    // MARK: - Configure Cell with Data
    func configure(with reward: RewardModel) {
        tierIcon.image = reward.tierImage
        tierLabel.text = reward.tierName
        entryLabel.text = reward.entryLevel
        descriptionLabel.text = reward.description
        rewardBonusLabel.text = reward.bonusPoints
        freeShippingLabel.text = reward.freeShipping
        tierBonusLabel.text = reward.tierBonus
    }
}


class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12) // Adjust padding as needed
    
    override func drawText(in rect: CGRect) {
        let insetsRect = rect.inset(by: textInsets)
        super.drawText(in: insetsRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }
}
