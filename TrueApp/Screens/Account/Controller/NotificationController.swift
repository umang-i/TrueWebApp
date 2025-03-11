//
//  NotificationController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class NotificationController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    private var settings: [NotificationSetting] = [
        NotificationSetting(title: "Order Notifications", isEnabled: true),
        NotificationSetting(title: "Basket Notifications", isEnabled: true),
        NotificationSetting(title: "Wallet Notifications", isEnabled: true),
        NotificationSetting(title: "Promotion / Offer Notifications", isEnabled: true)
    ]

    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let firstTableView = UITableView()
    private let secondTableView = UITableView()
    private let bannerView = UIView()
    private let backInStockLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavBar()
        setupScrollView()
        setupBannerView()
        setupFirstTableView()
        setupBackInStockLabel()
        setupSecondTableView()
    }

    private func setNavBar() {
        let navBar = CustomNavBar(text: "Notification Preferences")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupBannerView() {
        bannerView.backgroundColor = .white
        let bannerImageView = UIImageView()
        bannerImageView.image = UIImage(named: "gif")
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerView.addSubview(bannerImageView)
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: bannerView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: bannerView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: bannerView.trailingAnchor),
            bannerImageView.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
        ])

        contentView.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 120)
        ])
    }

    private func setupFirstTableView() {
        firstTableView.delegate = self
        firstTableView.dataSource = self
        firstTableView.register(NotificationPrefCell.self, forCellReuseIdentifier: "NotificationPrefCell")
        firstTableView.separatorStyle = .none
        firstTableView.tableFooterView = UIView()
        firstTableView.isScrollEnabled = false

        contentView.addSubview(firstTableView)
        firstTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstTableView.topAnchor.constraint(equalTo: bannerView.bottomAnchor, constant: 20),
            firstTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstTableView.heightAnchor.constraint(equalToConstant: CGFloat(settings.count * 95)) // Dynamic height
        ])
    }

    private func setupBackInStockLabel() {
        backInStockLabel.text = "Back In Stock Notifications"
        backInStockLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        backInStockLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(backInStockLabel)

        NSLayoutConstraint.activate([
            backInStockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backInStockLabel.topAnchor.constraint(equalTo: firstTableView.bottomAnchor, constant: 10)
        ])
    }

    private func setupSecondTableView() {
        secondTableView.delegate = self
        secondTableView.dataSource = self
        secondTableView.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        secondTableView.tableFooterView = UIView()
        secondTableView.separatorStyle = .none
        secondTableView.isScrollEnabled = false

        contentView.addSubview(secondTableView)
        secondTableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            secondTableView.topAnchor.constraint(equalTo: backInStockLabel.bottomAnchor, constant: 10),
            secondTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            secondTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            secondTableView.heightAnchor.constraint(equalToConstant: 60),
            secondTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - UITableView Delegate & DataSource
extension NotificationController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == firstTableView) ? settings.count : 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == firstTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationPrefCell", for: indexPath) as? NotificationPrefCell else {
                return UITableViewCell()
            }
            let setting = settings[indexPath.row]
            cell.configure(with: setting) { [weak self] isEnabled in
                self?.settings[indexPath.row].isEnabled = isEnabled
            }
            return cell
        } else if tableView == secondTableView {
            return tableView.dequeueReusableCell(withIdentifier: "StockCell", for: indexPath) as? StockCell ?? UITableViewCell()
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView == secondTableView) ? 50 : UITableView.automaticDimension
    }
}
