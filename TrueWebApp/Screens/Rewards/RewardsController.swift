//
//  RewardsController.swift
//  TrueApp
//
//  Created by Umang Kedan on 06/03/25.
//

import UIKit

class RewardsController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var referView: UIView!
    @IBOutlet weak var rewardTableView: UITableView!
    private let rewards: [RewardModel] = [
        RewardModel(
            tierImage: UIImage(named: "bronze"),
            tierName: "Bronze",
            entryLevel: "ENTRY",
            description: "Earn 0 points to achieve this tier with exclusive rewards and benefits.",
            progress: 0.2,  // 20% progress
            progressText: "Earn 1500 more points to reach Silver",
            bonusPoints: "Reward bonus point\n+50 points",
            freeShipping: "Free shipping up to $30\nUse the code at checkout for free shipping.",
            tierBonus: "Tier bonus points\nEarn 5.00% more points for “Place an order”."
        ),
        RewardModel(
            tierImage: UIImage(named: "silver"),
            tierName: "Silver",
            entryLevel: "MID",
            description: "Earn 500 points to achieve this tier with better rewards.",
            progress: 0.5,  // 50% progress
            progressText: "Earn 1000 more points to reach Gold",
            bonusPoints: "Reward bonus point\n+100 points",
            freeShipping: "Free shipping up to $50\nUse the code at checkout for free shipping.",
            tierBonus: "Tier bonus points\nEarn 10.00% more points for “Place an order”."
        ),
        RewardModel(
            tierImage: UIImage(named: "gold"),
            tierName: "Gold",
            entryLevel: "PREMIUM",
            description: "Earn 1000 points to achieve this tier with maximum rewards.",
            progress: 1.0,  // 100% progress (Gold achieved)
            progressText: "You are at the highest tier!",
            bonusPoints: "Reward bonus point\n+200 points",
            freeShipping: "Free shipping up to $100\nUse the code at checkout for free shipping.",
            tierBonus: "Tier bonus points\nEarn 20.00% more points for “Place an order”."
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rewardTableView.register(RewardCell.self, forCellReuseIdentifier: "RewardCell")
        rewardTableView.rowHeight = UITableView.automaticDimension
        rewardTableView.delegate = self
        rewardTableView.dataSource = self
        rewardTableView.separatorStyle = .none
        let height = rewards.count * 430
        rewardTableView.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        setnavBar()
        setupReferViewTap()
    }
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "Loyalty Rewards")
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
    private func setupReferViewTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(referViewTapped))
        referView.isUserInteractionEnabled = true
        referView.addGestureRecognizer(tapGesture)
    }

    @objc private func referViewTapped() {
        let referVC = ReferController() // Or use storyboard ID if you're using Storyboards
        navigationController?.pushViewController(referVC, animated: true)
    }
}

extension RewardsController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell", for: indexPath) as? RewardCell else {
            return UITableViewCell()
        }
        cell.configure(with: rewards[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}
