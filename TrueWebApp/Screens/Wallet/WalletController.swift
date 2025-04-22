//
//  WalletController.swift
//  TrueApp
//
//  Created by Umang Kedan on 19/02/25.
//

import UIKit

class WalletViewController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setnavBar()
    }

    func setupUI() {
        view.backgroundColor = .white

        // Scroll View
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)

        // Content View
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Scroll View Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // Ensures scrollability
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Banner Image View
        let bannerImageView = UIImageView()
        bannerImageView.image = UIImage(named: "bnr1") // Replace with your image name
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bannerImageView)
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60), // Keeps spacing same
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 120)
        ])

        // Your Wallet Balance Label
        let walletBalanceLabel = UILabel()
        walletBalanceLabel.text = "Your Wallet Balance"
        walletBalanceLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        walletBalanceLabel.textColor = .black
        walletBalanceLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(walletBalanceLabel)
        NSLayoutConstraint.activate([
            walletBalanceLabel.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
            walletBalanceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            walletBalanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        // Wallet Balance Section
        let balanceContainer = UIView()
        balanceContainer.layer.borderWidth = 1
        balanceContainer.layer.borderColor = UIColor.customBlue.cgColor
        balanceContainer.layer.cornerRadius = 4
        balanceContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        balanceContainer.translatesAutoresizingMaskIntoConstraints = false

        let balanceIcon = UIImageView(image: UIImage(named: "wallet"))
        balanceIcon.tintColor = .customBlue
        balanceIcon.heightAnchor.constraint(equalToConstant: 26).isActive = true
        balanceIcon.widthAnchor.constraint(equalToConstant: 26).isActive = true

        let balanceLabel = UILabel()
        balanceLabel.text = "£2.50"
        balanceLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        balanceLabel.textColor = .customBlue

        let creditLabel = UILabel()
        creditLabel.text = "Credit"
        creditLabel.font = UIFont(name: "Roboto-Bold", size: 24)
        creditLabel.textColor = .customBlue

        let balanceStack = UIStackView(arrangedSubviews: [balanceIcon, balanceLabel, creditLabel])
        balanceStack.axis = .horizontal
        balanceStack.spacing = 10
        balanceStack.alignment = .center

        balanceContainer.addSubview(balanceStack)
        balanceStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            balanceStack.centerXAnchor.constraint(equalTo: balanceContainer.centerXAnchor),
            balanceStack.centerYAnchor.constraint(equalTo: balanceContainer.centerYAnchor)
        ])

        contentView.addSubview(balanceContainer)
        NSLayoutConstraint.activate([
            balanceContainer.topAnchor.constraint(equalTo: walletBalanceLabel.bottomAnchor, constant: 10),
            balanceContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            balanceContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])

        // Information Section
        let infoText = [
            ("What is the wallet?", "The wallet contains credit you acquired from previous purchases on this platform."),
            ("How much credit do I get?", "Every product has a wallet indicator stating how much credit you'll earn."),
            ("How do I use my credit?", "Your wallet credit will be applied as a discount on your next purchase."),
            ("Do I get credit if I don't use the platform?", "No. Credit is only added when you purchase through this platform.")
        ]

        let infoStack = UIStackView()
        infoStack.axis = .vertical
        infoStack.spacing = 10
        infoStack.translatesAutoresizingMaskIntoConstraints = false

        for (title, desc) in infoText {
            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
            titleLabel.textColor = .black

            let descLabel = UILabel()
            descLabel.text = desc
            descLabel.font = UIFont(name: "Roboto-Regular", size: 14)
            descLabel.textColor = .darkGray
            descLabel.numberOfLines = 0

            let textStack = UIStackView(arrangedSubviews: [titleLabel, descLabel])
            textStack.axis = .vertical
            textStack.spacing = 5
            infoStack.addArrangedSubview(textStack)
        }

        contentView.addSubview(infoStack)
        NSLayoutConstraint.activate([
            infoStack.topAnchor.constraint(equalTo: balanceContainer.bottomAnchor, constant: 20),
            infoStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            infoStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        // Ensure contentView has enough height
        NSLayoutConstraint.activate([
            infoStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Keeps the last element pinned
        ])
    }
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Wallet")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            // Background View Constraints (covers top of the screen)
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed

            // CustomNavBar Constraints
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
