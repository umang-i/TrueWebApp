//
//  ShopController.swift
//  TrueApp
//
//  Created by Umang Kedan on 24/02/25.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    var items: [Product] = []
    var scrollView: UIScrollView!
    var sortButton: UIButton!
    private var filterView: FilterView?

    var tableView: UITableView!
    var dealTableView: UITableView!

    var categories: [Category] = []

    var filteredCategories: [Category] = []
    var overlayView = UIView()

    private var cartView: UIView!
    private var cartItemCountLabel: UILabel!
    private var cartTotalLabel: UILabel!
    private var cartTextLabel: UILabel!
    private var viewBasketButton: UIButton!
    private var cartItems: [Product: Int] = [:]

    var expandedCategoryIndex: Int? = nil
    var expandedSubcategoryIndex: IndexPath? = nil

    var collectionView: UICollectionView!
    var selectedBrands: Set<String> = []

    var expandedCategories: Set<Int> = []
    var expandedSubcategories: [IndexPath: Bool] = [:]

    var selectedProductOption: String = "All"
    var selectedStockOption: String = "All"
    var filterScrollView: UIScrollView!
    var contentStack: UIStackView!
    var searchTextField: UITextField!
    let searchSortView = UIView()

    var tableViewHeightConstraint: NSLayoutConstraint!

    var bannerCollectionView: UICollectionView!
    var img: [String] = [
        "bnr1",  "s6" ,"s2" , "s1" , "s3","s4","s5"
    ]
    var bannerImages: [String] = [
        "d1" ,"d2" , "d3" , "d4","d5","d6","d1" ,"d2" , "d3" , "d4","d5","d6"
    ]
    
    var bannerTimer: Timer?
    var currentBannerIndex = 0

    var containerView = UIView()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupBannerCollectionView()
        startBannerAutoScroll()
        setupSearchAndSortBar()
        setupTableView()

        if let loadedCategories = loadCategoriesFromJSON() {
            categories = loadedCategories
        }
        print(categories)
        setupOverlayView()
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
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
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func setupBannerCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width, height: 100)

        bannerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        bannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bannerCollectionView.isPagingEnabled = true
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.showsHorizontalScrollIndicator = false
        bannerCollectionView.register(BannerImageCelll.self, forCellWithReuseIdentifier: "BannerImageCelll")
        bannerCollectionView.layer.cornerRadius = 10
        bannerCollectionView.contentMode = .scaleAspectFill

        containerView.addSubview(bannerCollectionView) // Add to containerView

        NSLayoutConstraint.activate([
            bannerCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 140), // Use containerView.topAnchor
            bannerCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor , constant: 10),
            bannerCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor , constant: -10),
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 127)
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
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(1)
        overlayView.isHidden = true // Initially hidden
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: searchSortView.bottomAnchor, constant: 5),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.heightAnchor.constraint(equalToConstant: 500)
        ])
    }

    @objc func toggleOverlay() {
        overlayView.isHidden.toggle()
        tableView.isHidden.toggle()
    }

    func startBannerAutoScroll() {
        bannerTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollBanner), userInfo: nil, repeats: true)
    }

    @objc func scrollBanner() {
        if currentBannerIndex < img.count - 1 {
            currentBannerIndex += 1
        } else {
            currentBannerIndex = 0
        }
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCategories = categories
        } else {
            filteredCategories = categories.filter { $0.title.lowercased().contains(searchText.lowercased()) }
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
        tableView.register(ExpandableCell.self, forCellReuseIdentifier: "ExpandableCell")
        tableView.register(GridTableCell.self, forCellReuseIdentifier: "GridCell")

        containerView.addSubview(tableView)

        // Set dynamic height constraint
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 1) // Temporary value
        tableViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bannerCollectionView.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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


    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
        if expandedCategories.contains(section) {
            var count = 1
            for (_, _) in category.subCats.enumerated() {
                let subcategoryIndexPath = IndexPath(row: count, section: section)
                count += 1
                if expandedSubcategories[subcategoryIndexPath] == true {
                    count += 1
                }
            }
            return count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            return 50
        }

        var rowIndex = 1
        for (_, subcategory) in category.subCats.enumerated() {
            let subcategoryIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
            if rowIndex == indexPath.row {
                return 50
            }
            rowIndex += 1
            if expandedSubcategories[subcategoryIndexPath] == true {
                if rowIndex == indexPath.row {
                    let rows = ceil(Double(subcategory.products.count) / 2.0)
                    return CGFloat((rows * 258) + 100) + 10
                }
                rowIndex += 1
            }
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]

        // Main category cell (row 0)
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
            let isExpanded = expandedCategories.contains(indexPath.section)
            // No icon for main category
            cell.configure(title: category.title, icon: nil, isExpanded: isExpanded)
            return cell
        }

        var rowIndex = 1
        for (subIndex, subcategory) in category.subCats.enumerated() {
            let subcategoryIndexPath = IndexPath(row: rowIndex, section: indexPath.section)

            // Subcategory title cell
            if rowIndex == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                let isExpanded = expandedSubcategories[subcategoryIndexPath] ?? false
                // Use subIndex to get the image correctly
                let icon = subIndex < bannerImages.count ? UIImage(named: bannerImages[subIndex]) : nil
                cell.configure(title: subcategory.title, icon: icon, isExpanded: isExpanded, isSubCell: true)
                return cell
            }

            rowIndex += 1

            // Subcategory expanded grid cell
            if expandedSubcategories[subcategoryIndexPath] == true {
                if rowIndex == indexPath.row {
                    let gridCell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as! GridTableCell
                    gridCell.configure(items: subcategory.products, name: subcategory.title)
                    return gridCell
                }
                rowIndex += 1
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if expandedCategories.contains(indexPath.section) {
                expandedCategories.remove(indexPath.section)
            } else {
                expandedCategories.insert(indexPath.section)
            }
            
            // Scroll the table view a little bit upwards after expansion
            let selectedCellRect = tableView.rectForRow(at: indexPath)
            let targetOffsetY = selectedCellRect.origin.y - 5
            
            // Ensure the offset stays within the bounds of the content
            let targetContentOffset = CGPoint(x: 0, y: max(targetOffsetY, 0))
            scrollView.setContentOffset(targetContentOffset, animated: false)  // Set the scroll without animation
            
        } else {
            let subcategoryIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            expandedSubcategories[subcategoryIndexPath] = !(expandedSubcategories[subcategoryIndexPath] ?? false)
        }
        
        tableView.reloadSections([indexPath.section], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
}

extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return img.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerImageCelll", for: indexPath) as! BannerImageCelll
        cell.imageView.image = UIImage(named: img[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

class BannerImageCelll: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
