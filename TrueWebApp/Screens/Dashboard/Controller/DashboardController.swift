//
//  DashboardController.swift
//  TrueApp
//
//  Created by Umang Kedan on 10/02/25.
//

import UIKit

class DashboardController: UIViewController, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @IBOutlet weak var dashView: UIView!
    @IBOutlet weak var dashScrollView: UIScrollView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var banner3CollectionView: UICollectionView!
    @IBOutlet weak var banner2CollectionView: UICollectionView!
    @IBOutlet weak var cartCollectionView: UICollectionView!
    @IBOutlet weak var circleCollectionView: UICollectionView!
    @IBOutlet weak var recentNotifLabel: UILabel!
    @IBOutlet weak var notifHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var notificationsTableView: UITableView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var imgPageController: UIPageControl!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    
    var browsebanners: [BrowseBanner] = []
    var bigBanner : [BigSlider] = []
    var fruitImage : [FruitSlider] = []
    var dealsImages : [DealSlider] = []
    var roundImage : [RoundSlider] = []
    var cdnUrl = ""
    
    var timer : Timer?
    var currentIndex = 0
    var item: [Products] = []
    var categories: [Categoryy] = []
    var cartItems : [CartItem] = []
    
    var isLoadingCart : Bool = true
    var isLoadingBanner : Bool = true
    var isLoadingBigBanner : Bool = true
    
    private let refreshControl = UIRefreshControl()
    let loaderView = CustomLoaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setupUI()
        setupLoaderView()
        setupTableViews()
        setupTapGesture()
        setCollectionView()
        gradientView.applyGradientBackground()
        fetchSlider()
        fetchRoundSlider()
        fetchBanners()
        fetchCat()
        loadDealsSliders()
        loadFruitSliders()
        setupPanGesture()
    }
    
    func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self // So we can allow simultaneous gestures
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: dashScrollView)

        if dashScrollView.contentOffset.y <= 0 && translation.y > 100 && loaderView.isHidden {
            print("🔄 Triggering custom refresh")
            beginCustomRefresh()
        }
    }

    
    override func viewDidLayoutSubviews() {
        print("📏 dashScrollView.contentSize:", dashScrollView.contentSize)
    }

    func fetchCat(){
        ApiService().fetchCategories(keyword: "") { result in
            switch result {
            case .success(let response):
                // Flattening categories from all main categories
                let allCategories = response.mainCategories.flatMap { $0.categories ?? [] }
                print("Fetched \(allCategories.count) categories")

                DispatchQueue.main.async {
                    self.categories = allCategories
                    self.cartCollectionView.reloadData()
                    self.banner3CollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSlider(){
        ApiService.shared.fetchBigSliders{
            result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.bigBanner = response.bigSliders
                    print(self.bigBanner.count)
                    self.isLoadingBigBanner = false
                    self.bannerCollectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching categories: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ApiService().fetchCartItems { result in
            switch result {
            case .success(let cartResponse):
                DispatchQueue.main.async {
                    self.cartItems = cartResponse.cartItems
                    self.isLoadingCart = false
                    self.cartCollectionView.reloadData()
                    self.cartCollectionView.collectionViewLayout.invalidateLayout()
                    for item in cartResponse.cartItems {
                        let price = Double(item.product.price)
                        CartManager.shared.updateCartItem(mVariantId: item.product.mvariant_id, quantity: item.quantity, price: price)
                    }
                }
            case .failure(let error):
                print("Error fetching cart items:", error.localizedDescription)
            }
        }
    }
    
    func fetchBanners() {
        ApiService.shared.fetchBrowseBanners { result in
            switch result {
            case .success(let bannerResponse):
                DispatchQueue.main.async {
                    self.browsebanners = bannerResponse.browseBanners
                    self.isLoadingBanner = false
                    self.itemsCollectionView.reloadData()
                    self.imgPageController.numberOfPages = self.browsebanners.count
                }
            case .failure(let error):
                print("Error fetching browse banners:", error.localizedDescription)
            }
        }
    }
    
    func loadFruitSliders() {
        ApiService.shared.fetchFruitSliders { result in
            switch result {
            case .success(let response):
                print("Sliders:", response.fruitSliders)
                print("CDN URL:", response.cdnURL)
                self.fruitImage = response.fruitSliders
                self.cdnUrl = response.cdnURL
                self.banner2CollectionView.reloadData()
            case .failure(let error):
                print("Error loading fruit sliders:", error.localizedDescription)
            }
        }
    }
    
    func loadDealsSliders() {
        ApiService.shared.fetchDealsSliders { result in
            switch result {
            case .success(let response):
                self.dealsImages = response.dealsSliders
                self.catCollectionView.reloadData()
            case .failure(let error):
                print("Failed to fetch deals sliders:", error.localizedDescription)
            }
        }
    }
    
    func fetchRoundSlider(){
        ApiService.shared.fetchRoundSliders{ result in
            DispatchQueue.main.async {
                switch result {
                case .success(let sliders):
                    print("Loaded sliders:", sliders.count)
                    DispatchQueue.main.async {
                        self.roundImage = sliders
                        self.circleCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Error fetching sliders:", error.localizedDescription)
                }
            }
        }
    }
    
    private func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true // hidden initially
        view.addSubview(loaderView) // ✅ not scrollView!

        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 70),
            loaderView.widthAnchor.constraint(equalToConstant: 60),
            loaderView.heightAnchor.constraint(equalToConstant: 60)
        ])

        print("✅ loaderView added with frame: \(loaderView.frame)")
    }

    func setupUI(){
        recentNotifLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        dashScrollView.delegate = self
        dashScrollView.isScrollEnabled = true
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
        bannerCollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        itemsCollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        itemsCollectionView.isPagingEnabled = true
        imgPageController.numberOfPages = browsebanners.count
        imgPageController.currentPage = 0
        
        circleCollectionView.register(UINib(nibName: "CircleCategoryCell", bundle: nil), forCellWithReuseIdentifier: "circleCell")
        bannerCollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        circleCollectionView.delegate = self
        circleCollectionView.dataSource = self
        
        catCollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        catCollectionView.delegate = self
        catCollectionView.dataSource = self
        catCollectionView.isPagingEnabled = false
        
        cartCollectionView.register(GridCell.self, forCellWithReuseIdentifier: "gridCell")
        cartCollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        cartCollectionView.delegate = self
        cartCollectionView.dataSource = self
        cartCollectionView.isPagingEnabled = false
        
        banner2CollectionView.register(UINib(nibName: "BannerImageCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        banner2CollectionView.delegate = self
        banner2CollectionView.dataSource = self
        banner2CollectionView.isPagingEnabled = false
        
        banner3CollectionView.register(GridCell.self, forCellWithReuseIdentifier: "gridCell");
        banner3CollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        banner3CollectionView.delegate = self
        banner3CollectionView.dataSource = self
        banner3CollectionView.isPagingEnabled = false

        
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
        if let layout = cartCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 2
            layout.minimumLineSpacing = 2
        }
        if let layout = banner2CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
        }
        if let layout = banner3CollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 2
            layout.minimumLineSpacing = 2
        }
        
        bannerCollectionView.isPagingEnabled = true // Ensures smooth sliding
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.showsVerticalScrollIndicator = false
    
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
        imgPageController.numberOfPages = browsebanners.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == itemsCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            imgPageController.currentPage = page
        }
        
        if scrollView.contentOffset.y < -120 && !isRefreshing && loaderView.isHidden {
               print("🔄 Triggering refresh")
               beginCustomRefresh()
           }
    }
    
    var isRefreshing = false

    func beginCustomRefresh() {
        loaderView.isHidden = false
        view.bringSubviewToFront(loaderView)
        loaderView.startAnimating() // ✅ START animation

        fetchSlider()
        fetchBanners()
        fetchCat()
        loadDealsSliders()
        loadFruitSliders()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.endCustomRefresh()
        }
    }

    func endCustomRefresh() {
        loaderView.stopAnimating() // ✅ STOP animation
        loaderView.isHidden = true
    }

    @objc func slideToNext() {
        guard bigBanner.count > 0 else { return }

        if currentIndex < bigBanner.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
        }

        let indexPath = IndexPath(item: currentIndex, section: 0)
        if bannerCollectionView.numberOfItems(inSection: 0) > currentIndex {
            bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
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
        return  5
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
        //  presentModalShopViewController()
            navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension DashboardController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == banner3CollectionView {
            return categories.count
        }
        if collectionView == cartCollectionView {
            return categories.count
        }
        return 1
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       if collectionView == circleCollectionView {
           return roundImage.count
        } else if collectionView == bannerCollectionView {
            return bigBanner.count
        } else if collectionView == itemsCollectionView {
            return browsebanners.count
        }else if collectionView == catCollectionView {
            return dealsImages.count
        }else if collectionView == banner2CollectionView {
            return fruitImage.count
        }
        else if collectionView == banner3CollectionView {
            guard section < categories.count else { return 0 }
            let allProducts = categories[section].subcategories.flatMap { $0.products }
            return allProducts.count

        }else if collectionView == cartCollectionView{
            guard section < categories.count else { return 0 }
               let products = categories[section].subcategories.flatMap { $0.products }
               return products.count
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == circleCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "circleCell", for: indexPath) as? CircleCategoryCell else {
                return UICollectionViewCell()
            }
            let image = roundImage[indexPath.row]
            cell.setCell(categoryName: image.name, image: image.imagePath) // Set category cell
            return cell

        } else if collectionView == bannerCollectionView {
            if isLoadingBigBanner {
                guard let shimmerCell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerBannerCell", for: indexPath) as? ShimmerBannerCell else {
                    return UICollectionViewCell()
                }
                return shimmerCell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: bigBanner[indexPath.row].image , callerId: 0)
            return cell

        } else if collectionView == itemsCollectionView {
            if isLoadingBanner {
                guard let shimmerCell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerBannerCell", for: indexPath) as? ShimmerBannerCell else {
                    return UICollectionViewCell()
                }
                return shimmerCell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: browsebanners[indexPath.row].browsebannerImage, callerId: 1) // Set item image
            return cell
        }else if collectionView == catCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: dealsImages[indexPath.row].imagePath, callerId: 1) // Set item image
            return cell
        
        }else if collectionView == cartCollectionView {
            if isLoadingCart {
                guard let shimmerCell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerBannerCell", for: indexPath) as? ShimmerBannerCell else {
                    return UICollectionViewCell()
                }
                return shimmerCell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
                return UICollectionViewCell()
            }
            
            // Safely access the products
            let allProducts = categories[indexPath.section].subcategories.flatMap { $0.products }
            
            // Ensure the index is within range
            guard indexPath.row < allProducts.count else {
                print("Error: Index \(indexPath.row) is out of range for products in section \(indexPath.section)")
                return cell
            }
            
            let product = allProducts[indexPath.row]
            cell.configure(item: product, cartItems: cartItems)
            
            return cell
        }
        else if collectionView == banner2CollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as? BannerImageCell else {
                return UICollectionViewCell()
            }
            cell.setImages(imgName: fruitImage[indexPath.row].imagePath, callerId: 1) // Set item image
            return cell

        }else if collectionView == banner3CollectionView {
            if isLoadingCart {
                guard let shimmerCell = cartCollectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerBannerCell", for: indexPath) as? ShimmerBannerCell else {
                    return UICollectionViewCell()
                }
                return shimmerCell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gridCell", for: indexPath) as? GridCell else {
                return UICollectionViewCell()
            }
            guard indexPath.section < categories.count else {
                return UICollectionViewCell()
            }

            let allProducts = categories[indexPath.section].subcategories.flatMap { $0.products }

            guard indexPath.row < allProducts.count else {
                return UICollectionViewCell()
            }

            let product = allProducts[indexPath.row]
            cell.configure(item: product, cartItems: cartItems)

            return cell
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
        }else if collectionView == cartCollectionView {
            return CGSize(width: collectionView.frame.width * 0.45, height: collectionView.frame.height)
        }else if collectionView == banner2CollectionView  {
            return CGSize(width: 150, height: collectionView.frame.height) // Fixed size for circle items
        }else if collectionView == banner3CollectionView  {
            return CGSize(width: collectionView.frame.width * 0.45, height: collectionView.frame.height)
        }
        else{
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    // 🔹 Ensure no spacing between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == catCollectionView {
                   return 5
        } else if collectionView == banner2CollectionView {
                   return 5
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

