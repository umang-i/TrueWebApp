//
//  DashboardController.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class DashboardController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var banner3CollectionView: UICollectionView!
    @IBOutlet weak var banner2CollectionView: UICollectionView!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var circleCollectionView: UICollectionView!
    @IBOutlet weak var recentNotifLabel: UILabel!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var notifHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var imgPageController: UIPageControl!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    var bannerImages = ["b1" , "b2","b3" , "b4","b5" , "b6","b7" ,"b8"]
    var items = ["s6" ,"s3" , "s2" , "s1","s4","s5"]
    var img = ["d1" , "d2" , "d3","d4","d5","d6"]
    var imgs = ["im1","im2","im3","im4","im5","im6"]
    var imgs1 = ["f1","f2","f3","f4","f5","f6"]
    var home = ["h1","h2","h3","h4","h5","h6","h7","h8","h9","h10","h11","h12"]
    var text = ["Hyaat","Oxva","Oreo","Fanta","Lost Mary","Coca Cola"]
    var timer : Timer?
    var currentIndex = 0
    var item: [Product] = []
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        setupTableViews()
        setupTapGesture()
        setCollectionView()
      //  gradientView.applyGradientBackground()
        
        if let loadedCategories = loadCategoriesFromJSON() {
            categories = loadedCategories
        }
    }
    
    func setupUI(){
        recentNotifLabel.font = UIFont(name: "Roboto-Regular", size: 15)
    }
    
    func setupTableViews(){
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
    }
    
    func setCollectionView() {
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        
        circleCollectionView.register(UINib(nibName: "CircleCategoryCell", bundle: nil), forCellWithReuseIdentifier: "circleCell")
        circleCollectionView.delegate = self
        circleCollectionView.dataSource = self
        
        catCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        catCollectionView.isPagingEnabled = false
        
//        cartCollectionView.register(GridCell.self, forCellWithReuseIdentifier: "gridCell")
//        cartCollectionView.delegate = self
//        cartCollectionView.dataSource = self
//        cartCollectionView.isPagingEnabled = false
//        
//        banner2CollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
//        banner2CollectionView.delegate = self
//        banner2CollectionView.dataSource = self
//        banner2CollectionView.isPagingEnabled = false
//        
//        banner3CollectionView.register(GridCell.self, forCellWithReuseIdentifier: "gridCell");
//        banner3CollectionView.delegate = self
//        banner3CollectionView.dataSource = self
//        banner3CollectionView.isPagingEnabled = false

        
        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
            if let layout = itemsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumLineSpacing = 0
                layout.minimumInteritemSpacing = 0
            }
        if let layout = circleCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumInteritemSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        if let layout = catCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
//        if let layout = cartCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.minimumInteritemSpacing = 2
//            layout.minimumLineSpacing = 2
//        }
//        if let layout = banner2CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.minimumInteritemSpacing = 10
//            layout.minimumLineSpacing = 10
//        }
//        if let layout = banner3CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.scrollDirection = .horizontal
//            layout.minimumInteritemSpacing = 2
//            layout.minimumLineSpacing = 2
//        }
        
        bannerCollectionView.isPagingEnabled = true // Ensures smooth sliding
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsVerticalScrollIndicator = false
    
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
       // imgPageController.numberOfPages = bannerImages.count
    }

    
    @objc func slideToNext() {
        if currentIndex < bannerImages.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }
       // imgPageController.currentPage = currentIndex
        let indexPath = IndexPath(item: currentIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(navigateToWallet))
    }
    
    @objc func navigateToWallet() {
        let walletController = WalletViewController()
        self.navigationController?.pushViewController(walletController, animated: true)
    }
    
    @IBAction func allOrdersButtonTapped(_ sender: UIButton) {
        let orderController = OrdersController(nibName: "OrdersController", bundle: nil)
        self.navigationController?.pushViewController(orderController, animated: true)
    }
    
    @objc func navigateToReferView() {
        let referRetailerVC = ReferController()
        self.navigationController?.pushViewController(referRetailerVC, animated: true)
    }
    @IBAction func shopButtonAction(_ sender: Any) {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

extension DashboardController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return  2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // Each section has only one row
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView == notificationsTableView ? 15 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear // Transparent spacing
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  if tableView == notificationsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as? NotificationCell else {
                return UITableViewCell()
            }
            
            // Add border radius and color
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            cell.layer.borderColor = UIColor.customBlue.cgColor
            cell.layer.borderWidth = 1.0
            
            return cell
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView == notificationsTableView ? 50 : 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NotificationDetailController(nibName: "NotificationDetailController", bundle: nil)
          
            navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension DashboardController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == circleCollectionView {
           return img.count
        } else if collectionView == bannerCollectionView {
            return bannerImages.count

        } else if collectionView == itemsCollectionView {
            return items.count
        }else if collectionView == catCollectionView {
            return imgs.count
        }
//        else if collectionView == banner3CollectionView {
//            return categories[section].subCats.flatMap { $0.products }.count
//        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == circleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circleCell", for: indexPath) as? CircleCategoryCell else {
                return UICollectionViewCell()
            }
            cell.setCell(categoryName: text[indexPath.row], image: home[indexPath.row]) // Set category cell
            return cell

        } else if collectionView == bannerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: bannerImages[indexPath.row], callerId: 0)
            return cell

        } else if collectionView == itemsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: items[indexPath.row], callerId: 1) // Set item image
            return cell
        }else if collectionView == catCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: imgs[indexPath.row], callerId: 1) // Set item image
            return cell
        
//        }else if collectionView == cartCollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
//                return UICollectionViewCell()
//            }
//            let allProducts = categories[indexPath.section].subCats.flatMap { $0.products }
//                    let product = allProducts[indexPath.row]
//
//                    cell.configure(title: product.title,
//                                   image: product.img,
//                                   price: product.price,
//                                   wallet: product.sku,
//                                   brand: "Lays") 
//            return cell
//        } else if collectionView == banner2CollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
//                return UICollectionViewCell()
//            }
//            cell.setImages(imgName: imgs1[indexPath.row], callerId: 1) // Set item image
//            return cell

//        }else if collectionView == banner3CollectionView {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
//                return UICollectionViewCell()
//            }
//            let allProducts = categories[indexPath.section].subCats.flatMap { $0.products }
//                    let product = allProducts[indexPath.row]
//
//                    cell.configure(title: product.title,
//                                   image: product.img,
//                                   price: product.price,
//                                   wallet: product.sku,
//                                   brand: "Lays")  // Modify brand logic if needed
//                    
//                    return cell
        }
        return UICollectionViewCell()
    }
    
    // 🔹 Ensure cell size dynamically matches the collection view's size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == circleCollectionView {
            return CGSize(width: 75, height: 75) // Fixed size for circle items
        } else if collectionView == catCollectionView  {
            return CGSize(width: 150, height: collectionView.frame.height) // Fixed size for circle items
        } else if collectionView == circleCollectionView {
            return CGSize(width: 10, height: 50) // Fixed size for circle items
//        }else if collectionView == cartCollectionView {
//            return CGSize(width: collectionView.frame.width * 0.45, height: collectionView.frame.height)
//        }else if collectionView == banner2CollectionView  {
//            return CGSize(width: 150, height: collectionView.frame.height) // Fixed size for circle items
//        }else if collectionView == banner3CollectionView  {
//            return CGSize(width: collectionView.frame.width * 0.4, height: collectionView.frame.height)
        }
        else{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    // 🔹 Ensure no spacing between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == catCollectionView {
                   return 5
//        } else if collectionView == banner2CollectionView {
//                   return 5
               }
        return 0
    }
}

extension UIView {
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hex: "#032B5F").cgColor, // Top color
            UIColor(hex: "#4C84D3").cgColor  // Bottom color
        ]
        
        // Top to bottom direction
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // top center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)   // bottom center

        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.layer.cornerRadius
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
            blue: CGFloat(rgbValue & 0x0000FF) / 255,
            alpha: 1.0
        )
    }
}

