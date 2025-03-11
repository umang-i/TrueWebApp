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
    var categories: [Category] = [
        Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Blackfriars", name: "India's Magic Masala [100gms] Magic Masala Magic Masala", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms] Magic Masala Magic Masala", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms] Magic Masala Magic Masala", price: "£1.25", imageUrl: "lays")
            ]),
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays")
            ]),
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays")
            ]),
        ]),
        Category(title: "Flavors", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "India's Magic Masala [100gms]", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Mapping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "yap", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ]),Category(title: "Taping", isExpanded: false, subcategories: [
            Subcategory(title: "Flavors", isExpanded: false, gridItems: [
                Product(brand: "Lays", name: "Apple", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Mango", price: "£1.25", imageUrl: "lays"),
                Product(brand: "Lays", name: "Grape", price: "£1.25", imageUrl: "lays")
            ])
        ])]
    
    var filteredCategories: [Category] = []
    var overlayView = UIView()
    
    private var cartView: UIView!
       private var cartItemCountLabel: UILabel!
       private var cartTotalLabel: UILabel!
       private var cartTextLabel: UILabel!
       private var viewBasketButton: UIButton!
    private var cartItems: [Product : Int] = [:]
    
    var collectionView: UICollectionView!
    var selectedBrands: Set<String> = []
    
    let brands = ["Additional POS", "Airheads", "Airplane", "Al Fakher", "Aspire Gotek",
                  "Bar Juice 5000", "Bebeto", "Blackfriars", "Candy Break", "Canabar",
                  "Chupa Chups", "Crystal Clear", "D&K", "Duracell", "Edge", "Elements",
                  "ELFA Pro", "Energizer", "Fanta", "Goat", "Gold Bar", "Hayati", "Hot Chip",
                  "Jelly Rose", "JUUL", "Kit Kat", "Like Home", "Lost Mary BM6000", "IVG","Additional POS", "Airheads", "Airplane", "Al Fakher", "Aspire Gotek",
                  "Bar Juice 5000", "Bebeto", "Blackfriars", "Candy Break", "Canabar",
                  "Chupa Chups", "Crystal Clear", "D&K", "Duracell", "Edge", "Elements",
                  "ELFA Pro", "Energizer", "Fanta", "Goat", "Gold Bar", "Hayati", "Hot Chip",
                  "Jelly Rose", "JUUL", "Kit Kat", "Like Home", "Lost Mary BM6000", "IVG"]
    
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
        filteredCategories = categories
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
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
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
        var count = 1
        for subcategory in category.subcategories {
            if category.isExpanded {
                count += 1
                if subcategory.isExpanded {
                    count += 1
                }
            }
        }
        return count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            return 50 // Category cell
        } else {
            var rowIndex = 1
            for subcategory in category.subcategories {
                if rowIndex == indexPath.row {
                    return 50 + 5 // Add 5px space
                }
                rowIndex += 1
                if subcategory.isExpanded {
                    if rowIndex == indexPath.row {
                        let heights = 210 * ceil(Double(subcategory.gridItems.count) / 2) + 20
                        return CGFloat(heights) + 5 // Add 5px space
                    }
                    rowIndex += 1
                }
            }
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
            cell.configure(title: category.title, isExpanded: category.isExpanded)
            return cell
        } else {
            var rowIndex = 1
            for subcategory in category.subcategories {
                if rowIndex == indexPath.row {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableCell", for: indexPath) as! ExpandableCell
                    cell.configure(title: subcategory.title, isExpanded: subcategory.isExpanded, isSubCell: true)
                    
                    // Add bottom spacing
                    let spacerView = UIView()
                    spacerView.backgroundColor = .white
                    spacerView.translatesAutoresizingMaskIntoConstraints = false
                    cell.contentView.addSubview(spacerView)
                    
                    NSLayoutConstraint.activate([
                        spacerView.heightAnchor.constraint(equalToConstant: 5),
                        spacerView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                        spacerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                        spacerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor)
                    ])
                    
                    return cell
                }
                rowIndex += 1
                if subcategory.isExpanded {
                    if rowIndex == indexPath.row {
                        let gridCell = tableView.dequeueReusableCell(withIdentifier: "GridCell", for: indexPath) as! GridTableCell
                        gridCell.configure(items: subcategory.gridItems)
                        return gridCell
                    }
                    rowIndex += 1
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.section]
        if indexPath.row == 0 {
            category.isExpanded.toggle()
        } else {
            var rowIndex = 1
            for i in 0..<category.subcategories.count {
                if rowIndex == indexPath.row {
                    category.subcategories[i].isExpanded.toggle()
                    break
                }
                rowIndex += 1
                if category.subcategories[i].isExpanded {
                    rowIndex += 1
                }
            }
        }
        categories[indexPath.section] = category
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

