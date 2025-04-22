//
//  GridTableCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 26/02/25.
//

import UIKit

class GridTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var item: [Product] = []
    var name: String?
    
    private let countdownView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customRed
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "OFFERS AND DISCOUNTS"
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 17)
        titleLabel.numberOfLines = 2
        titleLabel.widthAnchor.constraint(equalToConstant: 180).isActive = true
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        
        let countdownLabel = UILabel()
        countdownLabel.text = "06 : 07 : 49" 
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 28)
        countdownLabel.textColor = .white
        countdownLabel.textAlignment = .center
        
        let daysLabel = UILabel()
        daysLabel.text = "Days   Hours   Minutes"
        daysLabel.font = UIFont.systemFont(ofSize: 12)
        daysLabel.textColor = .white
        daysLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [ countdownLabel, daysLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hstackView = UIStackView(arrangedSubviews: [ titleLabel , stackView])
        hstackView.axis = .horizontal
        hstackView.spacing = 4
        hstackView.alignment = .center
        hstackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hstackView)
        
        NSLayoutConstraint.activate([
            hstackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hstackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hstackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 180, height: 250)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GridCell.self, forCellWithReuseIdentifier: "gridCell")
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(collectionView)
        contentView.addSubview(countdownView)
        
        NSLayoutConstraint.activate([
            countdownView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            countdownView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            countdownView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -0),
            countdownView.heightAnchor.constraint(equalToConstant: 60),
            
            collectionView.topAnchor.constraint(equalTo: countdownView.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        contentView.bringSubviewToFront(countdownView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(items: [Product], name: String) {
        self.item = items
        self.name = name
        collectionView.reloadData()
    }
    
    // UICollectionView DataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return item.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as! GridCell
        print(item[indexPath.row].title)
        cell.configure(title: item[indexPath.row].title,
                       image: item[indexPath.row].img,
                           price: "\(item[indexPath.row].price)",
                       wallet: "\(item[indexPath.row].price)", brand: name ?? "")
        return cell
    }
}

class ExpandableCell: UITableViewCell {

    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let offrLabel = UILabel()
    let arrowImageView = UIImageView()
    let spacerView = UIView()

    private var titleWithIconConstraint: NSLayoutConstraint!
    private var titleWithoutIconConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .customBlue

        iconImageView.contentMode = .scaleAspectFill
        iconImageView.layer.cornerRadius = 5
        iconImageView.layer.borderWidth = 1
        iconImageView.layer.borderColor = UIColor.black.cgColor
        iconImageView.clipsToBounds = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)

        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        offrLabel.text = "HOT"
        offrLabel.backgroundColor = .customRed
        offrLabel.textColor = .white
        offrLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        offrLabel.textAlignment = .center
        offrLabel.layer.cornerRadius = 10
        offrLabel.clipsToBounds = true
        offrLabel.translatesAutoresizingMaskIntoConstraints = false
        offrLabel.isHidden = true
        contentView.addSubview(offrLabel)

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
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),

            // Offer Label
            offrLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            offrLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -3),
            offrLabel.widthAnchor.constraint(equalToConstant: 40),
            offrLabel.heightAnchor.constraint(equalToConstant: 30),

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

    func configure(title: String, icon: UIImage?, isExpanded: Bool, isSubCell: Bool = false) {
        titleLabel.text = title

        if isSubCell {
            iconImageView.image = icon
            iconImageView.isHidden = false
            titleWithIconConstraint.isActive = true
            titleWithoutIconConstraint.isActive = false
        } else {
            iconImageView.image = nil
            iconImageView.isHidden = true
            titleWithIconConstraint.isActive = false
            titleWithoutIconConstraint.isActive = true
        }

        backgroundColor = (title == "Deals and offers") ? .customRed : (isSubCell ? .systemGray5 : .customBlue)

        arrowImageView.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")

        titleLabel.textColor = isSubCell ? .black : .white
        arrowImageView.tintColor = isSubCell ? .black : .white
        iconImageView.tintColor = isSubCell ? .black : .white

        offrLabel.isHidden = !isSubCell
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
