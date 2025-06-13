//
//  ShoppingController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 05/05/25.
//

import Foundation
import UIKit

// In FilterView.swift
protocol FilterViewDelegate: AnyObject {
    func didApplyFilter(selectedBrandIds: Set<String> , endchar : String)
}

class ShopController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate , FilterViewDelegate, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    var mainCategory : [MainCategory] = []
    var category : [Categoryy] = []
    var filteredCategories: [Categoryy] = []
    var subcategory : [Subcat] = []
    var product : [Products] = []
    var bannerImages: [String] = []
    
    var banners : [BrowseBanner] = []
    
    var expandedCategories: Set<IndexPath> = []
    var expandedSubcategories: [IndexPath: Bool] = [:] // [row, section] = isExpanded
    var expandedMainCategories: Set<Int> = []
    
    var scrollView: UIScrollView!
    var containerView = UIView()
    var tableView: UITableView!
    var bannerCollectionView: UICollectionView!
    
    var sortButton: UIButton!
    var overlayView: FilterView!
    var searchTextField: UITextField!
    let searchSortView = UIView()
    
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    var bannerTimer: Timer?
    var currentBannerIndex = 0
    
    private var searchTimer: Timer?
    
    var selectedBrandIds: Set<String> = []
    
    var noDataLabel: UILabel!
    
    var cartItems : [CartItem] = []
    
    var isLoading = true
    var isLoadingBanners = true
    var isRefreshing = true
    var isCartLoading = false

    let refreshControl = UIRefreshControl()
    let loaderView = CustomLoaderView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupSearchAndSortBar()
        setupBannerCollectionView()
        setupNoDataLabel()
        loadBannerData()
        startBannerAutoScroll()
        setupTableView()
        setupOverlayView()
        setupLoaderView()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleBannerPan(_:)))
        panGesture.delegate = self
        scrollView.addGestureRecognizer(panGesture)
        
        fetchCategories()
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchCategories()

        isLoading = true
        tableView.reloadData() // Show shimmer rows
        fetchCart()
    }
    
    func fetchCart(){
        
        ApiService().fetchCartItems { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let cartResponse):
                    self.cartItems = cartResponse.cartItems
                    for item in cartResponse.cartItems {
                        let price = Double(item.product.price)
                        CartManager.shared.updateCartItem(mVariantId: item.product.mvariant_id, quantity: item.quantity, price: price)
                    }

                case .failure(let error):
                    print("Error fetching cart items:", error.localizedDescription)
                }

                self.tableView.reloadData() // Refresh actual data or empty state
            }
        }
    }
    
    private func setupLoaderView() {
            loaderView.translatesAutoresizingMaskIntoConstraints = false
            loaderView.isHidden = true
            loaderView.isUserInteractionEnabled = false

        view.addSubview(loaderView)

        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: bannerCollectionView.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: bannerCollectionView.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 50),
            loaderView.heightAnchor.constraint(equalToConstant: 50)
        ])
        }
    
    @objc func handleBannerPan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: scrollView)

        // Ensure it's a downward pull from the top of the scrollView
        if translation.y > 30 && scrollView.contentOffset.y <= 0 {
            if gesture.state == .ended && !isRefreshing {
                isRefreshing = true
                print("Pull down detected on scrollView - trigger refresh")
                showLoader()
                handleRefresh()
            }
        }
    }

    func showLoader() {
        loaderView.isHidden = false
        loaderView.startAnimating()
    }

    func hideLoader() {
        loaderView.stopAnimating()
        loaderView.isHidden = true
    }
    
    func handleRefresh() {
        isLoading = true
        isLoadingBanners = true

        bannerCollectionView.reloadData()
        tableView.reloadData()

        // Simulate fetching categories
        fetchCategories() { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.hideLoader()
            self.tableView.reloadData()
            
            // Now load banner data after categories
            self.loadBannerData(completion: {
                self.isLoadingBanners = false
                self.bannerCollectionView.reloadData()
                self.refreshControl.endRefreshing()
                self.isRefreshing = false
            })
        }
        fetchCart()
    }
    
    func fetchCategories(keyword: String = "", completion: (() -> Void)? = nil) {
        ApiService().fetchCategories(keyword: keyword.isEmpty ? (searchTextField.text ?? "") : keyword) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let allCategories = response.mainCategories.flatMap { $0.categories ?? [] }
                    print("Fetched \(allCategories.count) categories")
                    self.mainCategory = response.mainCategories
                    self.category = allCategories
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.tableView.layoutIfNeeded()
                    self.scrollView.layoutIfNeeded()
                    self.noDataLabel.isHidden = !self.category.isEmpty
                case .failure(let error):
                    print("Failed to fetch categories:", error.localizedDescription)
                }
                completion?()  // ✅ Always call the completion at the end
            }
        }
    }
    
    @objc private func searchTextChanged() {
        searchTimer?.invalidate()
        
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let keyword = self.searchTextField.text ?? ""
            self.fetchCategories(keyword: keyword)
        }
    }
    
    func loadBannerData(completion: (() -> Void)? = nil) {
        isLoadingBanners = true
        bannerCollectionView.reloadData()
        
        ApiService().fetchBrowseBanners { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoadingBanners = false
                self.isRefreshing = false
                switch result {
                case .success(let response):
                    self.bannerImages = response.browseBanners.map { response.cdnURL + $0.browsebannerImage }
                    self.banners = response.browseBanners
                    print("loadBannerData - Success: bannerImages count - \(self.bannerImages.count)")
                    self.bannerCollectionView.reloadData()
                    print("loadBannerData - Success: bannerCollectionView item count after reload - \(self.bannerCollectionView.numberOfItems(inSection: 0))")
                    self.startBannerAutoScroll()
                case .failure(let error):
                    print("Failed to fetch banners:", error.localizedDescription)
                }
                completion?()
            }
        }
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        view.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        
        // ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Container View Constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor), // Allows container to grow with content
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            
        ])
    }
    
    func setupBannerCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: containerView.frame.width - 20, height: 127) // Account for leading and trailing constraints
        
        bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bannerCollectionView.isPagingEnabled = true // Keep this for clean swipe-based scrolling
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.register(BannerImageCelll.self, forCellWithReuseIdentifier: "BannerImageCelll")
        bannerCollectionView.layer.cornerRadius = 10
        bannerCollectionView.contentMode = .scaleAspectFill
        bannerCollectionView.register(ShimmerBannerCell.self, forCellWithReuseIdentifier: "ShimmerBannerCell")
        
        containerView.addSubview(bannerCollectionView) // Add to containerView
        
        NSLayoutConstraint.activate([
            bannerCollectionView.topAnchor.constraint(equalTo: searchSortView.bottomAnchor, constant: 10), // Adjusted topAnchor
            bannerCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor , constant: 10),
            bannerCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: -10),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 127)
        ])
        
        // Ensure layout happens immediately to get the correct frame for itemSize
        bannerCollectionView.layoutIfNeeded()
        layout.itemSize = CGSize(width: bannerCollectionView.frame.width, height: 127)
        bannerCollectionView.collectionViewLayout = layout
    
    }
    
    func startBannerAutoScroll() {
        // Invalidate any existing timer
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollBanner), userInfo: nil, repeats: true)
    }
    
    
    @objc func scrollBanner() {
        if bannerImages.isEmpty {
            return // Don't try to scroll if there are no images
        }
        
        var nextIndex = currentBannerIndex + 1
        if nextIndex >= bannerImages.count {
            nextIndex = 0
        }
        
        let indexPath = IndexPath(item: nextIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentBannerIndex = nextIndex
    }
    
    // Optional: Pause auto-scroll when user interacts (e.g., starts dragging)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        bannerTimer?.invalidate()
    }
    
    // Optional: Resume auto-scroll after user interaction
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startBannerAutoScroll()
    }
    
    func setupNoDataLabel() {
        noDataLabel = UILabel()
        noDataLabel.text = "No Data"
        noDataLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        noDataLabel.textColor = .darkGray
        noDataLabel.textAlignment = .center
        noDataLabel.isHidden = true // Initially hidden
        noDataLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(noDataLabel)
        
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            noDataLabel.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 30)
        ])
    }
    
    func setupSearchAndSortBar() {
        // Create the container view for search bar and sort button
        
        searchSortView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(searchSortView)
        
        // Create the custom search text field
        searchTextField = UITextField()
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.delegate = self
        searchTextField.placeholder = "Search for products"
        searchTextField.backgroundColor = .systemGray5
        searchTextField.layer.masksToBounds = true
        searchTextField.font = UIFont.systemFont(ofSize: 16)
        searchTextField.autocorrectionType = .no
        searchTextField.autocapitalizationType = .none
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .whileEditing
        
        // Add left view (search icon)
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        let iconImageView = UIImageView(image: searchIcon)
        iconImageView.tintColor = .customBlue
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        iconImageView.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        iconContainerView.addSubview(iconImageView)
        searchTextField.leftView = iconContainerView
        searchTextField.leftViewMode = .always
        
        // Add the search text field to the container view
        searchSortView.addSubview(searchTextField)
        
        // Create the sort button
        sortButton = UIButton(type: .system)
        if let sortImage = UIImage(named: "sort") {
            sortButton.setImage(sortImage, for: .normal)
        } else {
            sortButton.setTitle("Sort", for: .normal) // Fallback text if image is not found
            print("⚠️ Image 'sort' not found in assets")
        }
        sortButton.tintColor = .customRed
        sortButton.addTarget(self, action: #selector(toggleOverlay), for: .touchUpInside)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the sort button to the container view
        searchSortView.addSubview(sortButton)
        
        // Set constraints for the container view
        NSLayoutConstraint.activate([
            searchSortView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 80),
            searchSortView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            searchSortView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            searchSortView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Set constraints for the search text field
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchSortView.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: sortButton.leadingAnchor, constant: -10),
            searchTextField.topAnchor.constraint(equalTo: searchSortView.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: searchSortView.bottomAnchor)
        ])
        
        // Set constraints for the sort button
        NSLayoutConstraint.activate([
            sortButton.trailingAnchor.constraint(equalTo: searchSortView.trailingAnchor),
            sortButton.widthAnchor.constraint(equalToConstant: 40),
            sortButton.heightAnchor.constraint(equalToConstant: 40),
            sortButton.centerYAnchor.constraint(equalTo: searchSortView.centerYAnchor)
        ])
    }
    
    func setupOverlayView() {
        overlayView = FilterView(frame: view.bounds)
        overlayView.delegate = self
        overlayView.isHidden = true
        overlayView.dismissAction = {
            self.toggleOverlay()
        }
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: searchSortView.bottomAnchor, constant: 5),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func didApplyFilter(selectedBrandIds: Set<String>, endchar: String) {
        self.selectedBrandIds = selectedBrandIds
        overlayView.isHidden = true // Hide the filter overlay
        
        // Fetch filtered categories
        ApiService().fetchFilteredCategories(selectedBrandIds: selectedBrandIds, endChar: searchTextField.text ?? "") { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    let allCategories = response.mainCategories.flatMap { $0.categories ?? [] }
                    print("Fetched \(allCategories.count) categories")
                    self.category = allCategories
                    self.tableView.reloadData()
                    self.tableView.isHidden = self.category.isEmpty
                    self.noDataLabel.isHidden = !self.category.isEmpty
                    self.scrollView.layoutIfNeeded()
                    
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                    self.noDataLabel.isHidden = false
                    self.category = [] // Clear the categories on failure
                    self.tableView.reloadData()
                }
            }
        }
    }

    @objc func toggleOverlay() {
        overlayView.isHidden.toggle()
        tableView.isHidden.toggle()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategories = category
        } else {
            filteredCategories = category.filter { $0.mcat_name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.sectionHeaderHeight = 10
        tableView.sectionHeaderTopPadding = 0
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.isUserInteractionEnabled = true
        tableView.isScrollEnabled = false // Important: Disable scrolling on the tableView
        tableView.register(ExpandableCell.self, forCellReuseIdentifier: "ExpandableCell")
        tableView.register(GridTableCell.self, forCellReuseIdentifier: "GridCell")
        tableView.register(ShimmerCell.self, forCellReuseIdentifier: "ShimmerCell")
        
        containerView.addSubview(tableView)
        
        // Set dynamic height constraint for the tableView
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1) // Temporary value
        tableViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 10) ,
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10), // Pin bottom of tableView to bottom of container
            tableViewHeightConstraint
        ])
        
        // Update TableView Height After Data Loads
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            let contentHeight = tableView.contentSize.height
            let minHeight = view.frame.height * 0.6 // Adjust this as needed
            
            // Set a minimum height to allow scrolling even when collapsed
            tableViewHeightConstraint.constant = max(contentHeight, minHeight)
            
            // Make sure the layout updates
            view.layoutIfNeeded()
        }
    }
    
    func expandToProduct(mcatId: Int, msubcatId: Int, mproductId: Int) {
        print("msubcat id \(msubcatId)")
        
        // Find category index
        guard let categoryIndex = category.firstIndex(where: { $0.mcat_id == mcatId }) else { return }
        let cat = category[categoryIndex]
        
        // Expand the category
        let categoryIndexPath = IndexPath(row: 0, section: categoryIndex)
        expandedCategories.insert(categoryIndexPath)
        
        // Find subcategory index
        guard let subcatIndex = cat.subcategories.firstIndex(where: { $0.msubcat_id == msubcatId }) else {
            tableView.reloadData()
            return
        }
        print("subcat id \(subcatIndex)")
        
        // Calculate subcategory title row index
        let subcatTitleRow = subcatIndex / 2 + 2
        let subcatIndexPath = IndexPath(row: subcatTitleRow, section: categoryIndex)
        
        // Mark subcategory as expanded
        expandedSubcategories[subcatIndexPath] = true
        print(subcatIndexPath)
        
        // Reload table
        tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.layoutIfNeeded()
            
            let sectionRect = self.tableView.rect(forSection: categoryIndex)
            print("Calculated Section Rect: \(sectionRect)")
            
            if let cell = self.tableView.cellForRow(at: IndexPath(row: subcatIndex * 2 + 2, section: categoryIndex)) {
                let cellRect = cell.convert(cell.bounds, to: self.scrollView)
                print("Calculated Cell Rect: \(cellRect)")
                self.scrollView.scrollRectToVisible(cellRect, animated: true)
            } else {
                print("Subcategory cell not found. Forcing a general section scroll.")
                self.scrollView.scrollRectToVisible(sectionRect, animated: true)
            }
        }
    }
}

extension ShopController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading { return 10 }
        let mainCat = mainCategory[section]
        let categoryList = mainCat.categories ?? []
        
        // Always count 1 for the main category row at the top of the section
        var totalRows = 1
        
        if expandedMainCategories.contains(section) {
            for (catIndex, category) in categoryList.enumerated() {
                totalRows += 1 // Category row
                
                let categoryIndexPath = IndexPath(row: catIndex, section: section)
                if expandedCategories.contains(categoryIndexPath) {
                    for (subIdx, subcat) in category.subcategories.enumerated() {
                        totalRows += 1 // Subcategory title
                        
                        let subcategoryIndexPath = IndexPath(row: subIdx, section: section)
                        if expandedSubcategories[subcategoryIndexPath] == true {
                            totalRows += 1 // Grid row
                        }
                    }
                }
            }
        }
        
        return totalRows
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isLoading ? 10 : mainCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShimmerCell", for: indexPath) as! ShimmerCell
            return cell
        }
        let mainCat = mainCategory[indexPath.section]
        let categories = mainCat.categories ?? []
        
        var currentRow = 0
        
        if indexPath.row == currentRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
            cell.selectionStyle = .none
            
            let isDeals = mainCat.mainMcatName.uppercased() == "DEALS & OFFERS"
            
            cell.configure(
                title: mainCat.mainMcatName,
                imageUrl: nil,
                isExpanded: expandedMainCategories.contains(indexPath.section),
                isSubCell: false,
                offerName: "",
                isCategoryCell: false
            )
            return cell
        }
        
        currentRow += 1
        
        // Only proceed if main category is expanded
        if expandedMainCategories.contains(indexPath.section) {
            for (catIndex, category) in categories.enumerated() {
                // Category Cell
                if indexPath.row == currentRow {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                    let isExpanded = expandedCategories.contains(IndexPath(row: catIndex, section: indexPath.section))
                    cell.configure(title: category.mcat_name, imageUrl: nil, isExpanded: isExpanded, isSubCell: false, offerName: "" , isCategoryCell: true)
                    return cell
                }
                currentRow += 1
                
                let categoryExpanded = expandedCategories.contains(IndexPath(row: catIndex, section: indexPath.section))
                if categoryExpanded {
                    for (subIndex, subcat) in category.subcategories.enumerated() {
                        let subcatIndexPath = IndexPath(row: subIndex, section: indexPath.section)
                        
                        // Subcategory Title Cell
                        if indexPath.row == currentRow {
                            let isExpanded = expandedSubcategories[subcatIndexPath] ?? false
                            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                            cell.configure(title: subcat.msubcat_name, imageUrl: "https://cdn.truewebpro.com/\(subcat.msubcat_image)", isExpanded: isExpanded, isSubCell: true, offerName: subcat.msubcat_tag ?? "" , isCategoryCell: false)
                            return cell
                        }
                        currentRow += 1
                        
                        // Subcategory Grid Cell
                        if expandedSubcategories[subcatIndexPath] == true {
                            if indexPath.row == currentRow {
                                let cell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as! GridTableCell
                                cell.configure(items: subcat.products, name: subcat.msubcat_name, offerName: subcat.offer_name ?? "", offerStartTime: subcat.start_time ?? "", offerEndTime: subcat.end_time ?? "", cart: cartItems)
                                return cell
                            }
                            currentRow += 1
                        }
                    }
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped section: \(indexPath.section), row: \(indexPath.row)")
        
        let mainCat = mainCategory[indexPath.section]
        let categoryList = mainCat.categories ?? []
        var currentRow = 0
        
        tableView.beginUpdates()
        
        // 1. Tapped Main Category Title
        if indexPath.row == currentRow {
            if expandedMainCategories.contains(indexPath.section) {
                // Collapse all expanded rows under this section
                expandedMainCategories.remove(indexPath.section)
                expandedCategories = expandedCategories.filter { $0.section != indexPath.section }
                expandedSubcategories = expandedSubcategories.filter { $0.key.section != indexPath.section }
                
                let totalRows = tableView.numberOfRows(inSection: indexPath.section)
                let indexPathsToDelete = (1..<totalRows).map { IndexPath(row: $0, section: indexPath.section) }
                tableView.deleteRows(at: indexPathsToDelete, with: .fade)
            } else {
                // Expand main category
                expandedMainCategories.insert(indexPath.section)
                let indexPathsToInsert = categoryList.enumerated().map { offset, _ in
                    IndexPath(row: currentRow + 1 + offset, section: indexPath.section)
                }
                tableView.insertRows(at: indexPathsToInsert, with: .fade)
            }
            
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            return
        }
        
        currentRow += 1
        
        // 2. Tapped Category or Subcategory Row
        for (catIndex, category) in categoryList.enumerated() {
            let categoryIndexPath = IndexPath(row: catIndex, section: indexPath.section)
            
            // Tapped category title
            if indexPath.row == currentRow {
                var indexPaths: [IndexPath] = []
                let subcategories = category.subcategories
                
                if expandedCategories.contains(categoryIndexPath) {
                    // Collapse subcategories (and their grids if expanded)
                    expandedCategories.remove(categoryIndexPath)
                    var row = currentRow + 1
                    
                    for (subIdx, _) in subcategories.enumerated() {
                        indexPaths.append(IndexPath(row: row, section: indexPath.section))
                        let subKey = IndexPath(row: subIdx, section: indexPath.section)
                        if expandedSubcategories[subKey] == true {
                            row += 1
                            indexPaths.append(IndexPath(row: row, section: indexPath.section))
                        }
                        expandedSubcategories.removeValue(forKey: subKey)
                        row += 1
                    }
                    
                    tableView.deleteRows(at: indexPaths, with: .fade)
                } else {
                    // Expand subcategories
                    expandedCategories.insert(categoryIndexPath)
                    var row = currentRow + 1
                    
                    for (subIdx, _) in subcategories.enumerated() {
                        let subIndexPath = IndexPath(row: row, section: indexPath.section)
                        indexPaths.append(subIndexPath)
                        expandedSubcategories[IndexPath(row: subIdx, section: indexPath.section)] = false
                        row += 1
                    }
                    
                    tableView.insertRows(at: indexPaths, with: .fade)
                }
                
                tableView.reloadRows(at: [indexPath], with: .none)
                tableView.endUpdates()
                return
            }
            
            currentRow += 1
            
            // Handle subcategory tap
            if expandedCategories.contains(categoryIndexPath) {
                for (subIdx, subcat) in category.subcategories.enumerated() {
                    let subTitleRow = currentRow
                    let subKey = IndexPath(row: subIdx, section: indexPath.section)
                    let gridRow = IndexPath(row: currentRow + 1, section: indexPath.section)
                    
                    if indexPath.row == subTitleRow {
                        let isExpanded = expandedSubcategories[subKey] ?? false
                        expandedSubcategories[subKey] = !isExpanded
                        
                        if isExpanded {
                            tableView.deleteRows(at: [gridRow], with: .fade)
                        } else {
                            tableView.insertRows(at: [gridRow], with: .fade)
                        }
                        
                        tableView.reloadRows(at: [indexPath], with: .none)
                        tableView.endUpdates()
                        return
                    }
                    
                    currentRow += 1
                    
                    if expandedSubcategories[subKey] == true {
                        if indexPath.row == currentRow {
                            print("Tapped grid for subcategory: \(subcat.msubcat_name)")
                            tableView.endUpdates()
                            return
                        }
                        currentRow += 1
                    }
                }
            }
        }
        
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLoading {
            return 60 // Match this to your actual cell height
        }
        let mainCat = mainCategory[indexPath.section]
        let categories = mainCat.categories ?? []
        
        var currentRow = 0
        
        // Main Category row
        if indexPath.row == currentRow {
            return 60
        }
        currentRow += 1
        
        if expandedMainCategories.contains(indexPath.section) {
            for (catIndex, category) in categories.enumerated() {
                // Category row
                if indexPath.row == currentRow {
                    return 60
                }
                currentRow += 1
                
                // Subcategories if category expanded
                if expandedCategories.contains(IndexPath(row: catIndex, section: indexPath.section)) {
                    for (subIdx, subcategory) in category.subcategories.enumerated() {
                        // Subcategory title row
                        if indexPath.row == currentRow {
                            return 60
                        }
                        currentRow += 1
                        
                        // Subcategory grid if expanded
                        if expandedSubcategories[IndexPath(row: subIdx, section: indexPath.section)] == true {
                            if indexPath.row == currentRow {
                                let rows = ceil(Double(subcategory.products.count) / 2.0)
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
                                
                                let shouldShowBanner: Bool
                                if let endTimeString = subcategory.end_time,
                                   let endTime = dateFormatter.date(from: endTimeString) {
                                    shouldShowBanner = Date() < endTime
                                } else {
                                    shouldShowBanner = false
                                }
                                
                                let bannerHeight: CGFloat = shouldShowBanner ? 60 : 0
                                let spacing: CGFloat = 5
                                
                                return CGFloat(rows * 260) + bannerHeight + spacing
                            }
                            currentRow += 1
                        }
                    }
                }
            }
        }
        
        return UITableView.automaticDimension
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isLoadingBanners ? 3 : bannerImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingBanners {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShimmerBannerCell", for: indexPath) as! ShimmerBannerCell
            return cell
        }
        else {  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCelll", for: indexPath) as! BannerImageCelll
        let imageUrlString = bannerImages[indexPath.row]
        
        if let url = URL(string: imageUrlString) {
            cell.imageView.load(url: url) // Use your custom image loading method
        } else {
            cell.imageView.image = UIImage(named: "noImage") // Default placeholder
        }
        return cell
    }
}
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < banners.count {
            print("Tapped cat id \(String(describing: banners[indexPath.row].mcatId)) \(String(describing: banners[indexPath.row].msubcatId)) \(String(describing: banners[indexPath.row].mproductId)) ")
            expandToProduct(mcatId: banners[indexPath.row].mcatId ?? 0, msubcatId: banners[indexPath.row].msubcatId ?? 0 , mproductId: banners[indexPath.row].mproductId ?? 0);
            
        } else {
            print("Error: Tapped banner index out of bounds.")
        }
    }
}

