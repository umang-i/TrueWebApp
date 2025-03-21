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
        layout.itemSize = CGSize(width: 185, height: 280)
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
    
    let titleLabel = UILabel()
    let arrowImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .customBlue
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        contentView.addSubview(titleLabel)
        
        arrowImageView.image = UIImage(systemName: "chevron.down")
        arrowImageView.tintColor = .white
        contentView.addSubview(arrowImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    func configure(title: String, isExpanded: Bool, isSubCell: Bool = false) {
        titleLabel.text = title
        arrowImageView.image = isExpanded ? UIImage(systemName: "chevron.up") : UIImage(systemName: "chevron.down")
        backgroundColor = isSubCell ? UIColor.systemGray5 : UIColor.customBlue
        titleLabel.textColor = isSubCell ? .black : .white
        arrowImageView.tintColor = isSubCell ? .black : .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


