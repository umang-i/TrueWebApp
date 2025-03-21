//
//  ShopController.swift
//  TrueApp
//
//  Created by Umang Kedan on 24/02/25.
//

import UIKit

class ShopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate {

    var items: [Product] = []
    var scrollView: UIScrollView!
    var sortButton: UIButton!
    private var filterView: FilterView?

    var tableView: UITableView!
    var dealTableView : UITableView!
    
    var categories: [Category] = []
    
    var filteredCategories: [Category] = []
    var overlayView = UIView()
    
    private var cartView: UIView!
    private var cartItemCountLabel: UILabel!
    private var cartTotalLabel: UILabel!
    private var cartTextLabel: UILabel!
    private var viewBasketButton: UIButton!
    private var cartItems: [Product : Int] = [:]
    
    var expandedCategoryIndex: Int? = nil
    var expandedSubcategoryIndex: IndexPath? = nil
    
    var collectionView: UICollectionView!
    var selectedBrands: Set<String> = []
    
    var expandedCategories: Set<Int> = [] // Stores expanded categories
    var expandedSubcategories: [IndexPath: Bool] = [:] // Tracks expanded subcategories per category


    
    var selectedProductOption: String = "All"
    var selectedStockOption: String = "All"
    var filterScrollView: UIScrollView!
    var contentStack: UIStackView!
    var searchTextField: UITextField!
    let searchSortView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchAndSortBar()
        setupTableView()
        
        if let loadedCategories = loadCategoriesFromJSON() {
            categories = loadedCategories
        }
        print(categories)
        setupOverlayView()
    }
    
    func setupSearchAndSortBar() {
        // Create the container view for search bar and sort button
       
        searchSortView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchSortView)

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
            searchSortView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            searchSortView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchSortView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
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
           overlayView =  FilterView(frame: view.bounds)
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
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = categories[section]
        
        if expandedCategories.contains(section) {
            var count = 1 // 1 for the category cell
            for (index, _) in category.subCats.enumerated() {
                let subcategoryIndexPath = IndexPath(row: count, section: section)
                count += 1 // For subcategory
                
                if expandedSubcategories[subcategoryIndexPath] == true {
                    count += 1 // Add extra row for grid cell
                }
            }
            return count
        } else {
            return 1 // Only show category if not expanded
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        
        if indexPath.row == 0 {
            return 50 // Category row height
        }

        var rowIndex = 1
        for (index, subcategory) in category.subCats.enumerated() {
            let subcategoryIndexPath = IndexPath(row: rowIndex, section: indexPath.section)

            if rowIndex == indexPath.row {
                return 50 // Subcategory row height
            }
            
            rowIndex += 1

            if expandedSubcategories[subcategoryIndexPath] == true {
                if rowIndex == indexPath.row {
                    let gridHeight = 300 * ceil(Double(subcategory.products.count) / 2) + 50
                                        return CGFloat(gridHeight) + 5
                    return gridHeight // Increased height for expanded subcategory grid
                }
                rowIndex += 1
            }
        }

        return UITableView.automaticDimension
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]

        // If first row, it's the main category cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
            let isExpanded = expandedCategories.contains(indexPath.section)
            cell.configure(title: category.title, isExpanded: isExpanded)
            return cell
        }

        var rowIndex = 1
        for (index, subcategory) in category.subCats.enumerated() {
            let subcategoryIndexPath = IndexPath(row: rowIndex, section: indexPath.section)
            
            if rowIndex == indexPath.row {
                // Subcategory cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                let isExpanded = expandedSubcategories[subcategoryIndexPath] ?? false
                cell.configure(title: subcategory.title, isExpanded: isExpanded, isSubCell: true)
                return cell
            }
            
            rowIndex += 1

            if expandedSubcategories[subcategoryIndexPath] == true {
                if rowIndex == indexPath.row {
                    // Grid cell
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
        if indexPath.row == 0 { // Category clicked
            if expandedCategories.contains(indexPath.section) {
                expandedCategories.remove(indexPath.section)
            } else {
                expandedCategories.insert(indexPath.section)
            }
            tableView.reloadSections([indexPath.section], with: .automatic)
        } else { // Subcategory clicked
            let subcategoryIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            
            if let isExpanded = expandedSubcategories[subcategoryIndexPath] {
                expandedSubcategories[subcategoryIndexPath] = !isExpanded
            } else {
                expandedSubcategories[subcategoryIndexPath] = true
            }
            
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear // You can set a light gray color if needed
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10 // Adjust the spacing as needed
    }

}
