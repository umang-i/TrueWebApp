//
//  CountdownView.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 20/03/25.
//

import Foundation
import UIKit

class CountdownView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "20P DRINKS DEAL COUNTDOWN"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.text = "06 : 07 : 49" // Placeholder
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "Days   Hours   Minutes"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, countdownLabel, daysLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    func updateCountdown(timeLeft: String) {
        countdownLabel.text = timeLeft
    }
}
