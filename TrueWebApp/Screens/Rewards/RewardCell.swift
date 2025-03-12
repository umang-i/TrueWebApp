//
//  RewardCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/03/25.
//

import UIKit

// MARK: - Reward Model
struct RewardModel {
    let tierImage: UIImage?  // Tier icon
    let tierName: String     // e.g., Bronze, Silver, Gold
    let entryLevel: String   // e.g., "ENTRY"
    let description: String  // Tier description
    let progress: Float      // Progress bar percentage (0.0 - 1.0)
    let progressText: String // Text below progress bar
    let bonusPoints: String  // Reward bonus points
    let freeShipping: String // Free shipping details
    let tierBonus: String    // Extra bonus points
}

// MARK: - Delegate Protocol for Claim Action
protocol RewardCellDelegate: AnyObject {
    func didTapClaimButton(for reward: RewardModel)
}

// MARK: - Reward Table View Cell
class RewardCell: UITableViewCell {
    
    // MARK: - Properties
    weak var delegate: RewardCellDelegate?
    private var rewardData: RewardModel?

    // MARK: - UI Elements
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    private let tierLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        return label
    }()
    
    private let entryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let progressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .customBlue
        progressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        return progressView
    }()
    
    private let progressTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.textColor = .lightGray
        return label
    }()
    
    private let rewardBonusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let freeShippingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let tierBonusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let claimButton: UIButton = {
        let button = UIButton()
        button.setTitle("CLAIM", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .customRed
        button.layer.cornerRadius = 4
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(containerView)
        
        claimButton.addTarget(self, action: #selector(claimButtonTapped), for: .touchUpInside)
        
        let tierStack = UIStackView(arrangedSubviews: [tierLabel, entryLabel])
        tierStack.axis = .vertical
        tierStack.spacing = 2
        tierStack.alignment = .leading
        
        let headStack = UIStackView(arrangedSubviews: [tierIcon, tierStack])
        headStack.axis = .horizontal
        headStack.spacing = 10
        headStack.alignment = .center

        let progressStack = UIStackView(arrangedSubviews: [progressBar, progressTextLabel])
        progressStack.axis = .vertical
        progressStack.spacing = 4
        progressStack.alignment = .fill

        let detailsStack = UIStackView(arrangedSubviews: [rewardBonusLabel, freeShippingLabel, tierBonusLabel, claimButton])
        detailsStack.axis = .vertical
        detailsStack.spacing = 8
        detailsStack.alignment = .leading

        containerView.addSubview(headStack)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(progressStack)
        containerView.addSubview(detailsStack)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        headStack.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        detailsStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            headStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            headStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            headStack.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -20),

            tierIcon.widthAnchor.constraint(equalToConstant: 80), // Set a fixed size
            tierIcon.heightAnchor.constraint(equalToConstant: 80), // Adjust as needed

            descriptionLabel.topAnchor.constraint(equalTo: headStack.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            progressStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            progressStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            progressStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            detailsStack.topAnchor.constraint(equalTo: progressStack.bottomAnchor, constant: 10),
            detailsStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            detailsStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            claimButton.heightAnchor.constraint(equalToConstant: 50),
            claimButton.widthAnchor.constraint(equalTo: detailsStack.widthAnchor),
            claimButton.topAnchor.constraint(equalTo: detailsStack.bottomAnchor, constant: 10)
        
        ])
    }


    
    // MARK: - Button Action
    @objc private func claimButtonTapped() {
        guard let reward = rewardData else { return }
        delegate?.didTapClaimButton(for: reward)
    }
    
    // MARK: - Configure Cell
    func configure(with reward: RewardModel) {
        self.rewardData = reward
        tierIcon.image = reward.tierImage
        tierLabel.text = reward.tierName
        entryLabel.text = reward.entryLevel
        descriptionLabel.text = reward.description
        progressBar.progress = reward.progress
        progressTextLabel.text = reward.progressText
        rewardBonusLabel.text = reward.bonusPoints
        freeShippingLabel.text = reward.freeShipping
        tierBonusLabel.text = reward.tierBonus
    }
}
