//
//  GridViewController.swift
//  TrueApp
//
//  Created by Umang Kedan on 26/02/25.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView!
    var items: [String]
    
    init(items: [String]) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "gridCell")
        view.addSubview(collectionView)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        
        collectionView.collectionViewLayout.invalidateLayout()
           collectionView.heightAnchor.constraint(equalToConstant: collectionView.contentSize.height).isActive = true

    }
    override func viewDidLayoutSubviews() {
          super.viewDidLayoutSubviews()
          collectionView.collectionViewLayout.invalidateLayout()
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: collectionView.frame.width - 20, height: UICollectionViewFlowLayout.automaticSize.height)
       }
}
