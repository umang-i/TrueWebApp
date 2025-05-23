//
//  GridTableCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 26/02/25.
//

import UIKit

class GridTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    var collectionView: UICollectionView!
    var item: [Products] = []
    var name: String?
    var titleOffer: String?
    var offerStartTime: String?
    var offerEndTime: String?
    var timing: String = ""
    private var countdownTimer: Timer?
    private var countdownHeightConstraint: NSLayoutConstraint?
    var cartItems: [CartItem] = []
    

    private let countdownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customRed
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 17)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.tag = 101 // For easy access later

        let countdownLabel = UILabel()
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 28)
        countdownLabel.textColor = .white
        countdownLabel.textAlignment = .center
        countdownLabel.tag = 102

        let daysLabel = UILabel()
        daysLabel.text = "Days    Hours    Minutes"
        daysLabel.font = UIFont.systemFont(ofSize: 12)
        daysLabel.textColor = .white
        daysLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [countdownLabel, daysLabel])
        stackView.axis = .vertical
        stackView.alignment = .center

        let hStackView = UIStackView(arrangedSubviews: [titleLabel, stackView])
        hStackView.axis = .horizontal
        hStackView.spacing = 10
        hStackView.alignment = .center
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(hStackView)
        NSLayoutConstraint.activate([
            hStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 250)
        layout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(countdownView)
        contentView.addSubview(collectionView)

        countdownHeightConstraint = countdownView.heightAnchor.constraint(equalToConstant: 0)
        countdownHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            countdownView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            countdownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            countdownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: countdownView.bottomAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [Products], name: String, offerName: String? = nil, offerStartTime: String? = nil, offerEndTime: String? = nil , cart: [CartItem]) {
        self.item = items
        self.name = name
        self.titleOffer = offerName
        self.offerStartTime = offerStartTime
        self.offerEndTime = offerEndTime
        self.cartItems = cart
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        // Set Offer Title
        if let titleLabel = countdownView.viewWithTag(101) as? UILabel {
            titleLabel.text = offerName?.uppercased()
        }

        let shouldShow = calculateTimeDifference()
        countdownHeightConstraint?.constant = shouldShow ? 65 : 0
        countdownView.isHidden = !shouldShow

        if shouldShow {
            startTimer()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    }
    
    private func startTimer() {
        countdownTimer?.invalidate()
        updateCountdown() // Immediate update on the main thread
        
        DispatchQueue.main.async {
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCountdown), userInfo: nil, repeats: true)
            RunLoop.main.add(self.countdownTimer!, forMode: .common)
        }
    }
 
    @objc private func updateCountdown() {
        DispatchQueue.main.async {
            self.calculateTimeDifference()
            if let countdownLabel = self.countdownView.viewWithTag(102) as? UILabel {
                countdownLabel.text = self.timing
            }
        }
    }

   
    @discardableResult
    func calculateTimeDifference() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
        
        guard let startTimeString = offerStartTime,
              let endTimeString = offerEndTime,
              let startTime = dateFormatter.date(from: startTimeString),
              let endTime = dateFormatter.date(from: endTimeString) else {
            timing = "Null"
            return false
        }

        let currentTime = Date()
        if currentTime >= startTime && currentTime < endTime {
            let timeDifference = endTime.timeIntervalSince(currentTime)
            let hours = Int(timeDifference / 3600)
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))
            timing = String(format: "%02d : %02d : %02d", hours, minutes, seconds)
            return true
        } else {
            timing = "Offer Ended"
            return false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        countdownTimer?.invalidate()
        countdownTimer = nil
        countdownHeightConstraint?.constant = 0
    }


    // UICollectionView DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }

//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridCell
//        cell.configure(item: item[indexPath.row])
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        let product = item[indexPath.item]
        cell.configure(item: product, cartItems: cartItems)
        return cell
    }
}

