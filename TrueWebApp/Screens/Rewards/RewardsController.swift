//
//  RewardsController.swift
//  TrueApp
//
//  Created by Umang Kedan on 06/03/25.
//

import UIKit

class RewardsController: UIViewController {

    @IBOutlet weak var rewardTableView: UITableView!
    
    private let rewards: [RewardModel] = [
           RewardModel(
               tierImage: UIImage(named: "bronze"),
               tierName: "Bronze",
               entryLevel: "ENTRY",
               description: "Earn 0 points to achieve this tier with exclusive rewards and benefits.",
               bonusPoints: "Reward bonus point\n+50 points",
               freeShipping: "Free shipping up to $30\nUse the code at checkout for free shipping.",
               tierBonus: "Tier bonus points\nEarn 5.00% more points for “Place an order”."
           ),
           RewardModel(
               tierImage: UIImage(named: "silver"),
               tierName: "Silver",
               entryLevel: "MID",
               description: "Earn 500 points to achieve this tier with better rewards.",
               bonusPoints: "Reward bonus point\n+100 points",
               freeShipping: "Free shipping up to $50\nUse the code at checkout for free shipping.",
               tierBonus: "Tier bonus points\nEarn 10.00% more points for “Place an order”."
           ),
           RewardModel(
               tierImage: UIImage(named: "gold"),
               tierName: "Gold",
               entryLevel: "PREMIUM",
               description: "Earn 1000 points to achieve this tier with maximum rewards.",
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
