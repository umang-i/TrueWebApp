//
//  FilterView.swift
//  TrueApp
//
//  Created by Umang Kedan on 07/03/25.
//

import UIKit

class FilterView: UIView {
    weak var delegate: FilterViewDelegate!
    
    var collectionView: UICollectionView!
    var selectedBrands: Set<String> = []
    
    var selectedBrandCallback: ((Set<String>) -> Void)?

    var brands : [Brand] = []
    var wishlistBrands : [Brand] = []
    var wishlistBrandIds: Set<String> = []
    var filteredBrands: [Brand] = []
    var selectedBrandIds: Set<String> = []
    
    var selectedProductOption: String = "All"
    var selectedStockOption: String = "All"
    var endChar : String = ""
    
    private let contentView = UIView()
    
    var dismissAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
        setupFilters()
        setupCollectionView()
        setupBottomButtons()
        fetchBrands()
    }
    
    func fetchBrands() {
        ApiService().fetchBrands { result in
            switch result {
            case .success(let brandResponse):
              //  print("Brands fetched successfully: \(brandResponse.mbrands)")
                DispatchQueue.main.async {
                    self.brands = brandResponse.mbrands
                    self.wishlistBrands = brandResponse.wishlistbrand
                    self.filteredBrands = self.brands // Display all by default
                    
                    // Store wishlist brand IDs as a set for efficient handling
                    self.wishlistBrandIds = Set(self.wishlistBrands.map { "\($0.mbrandID)" })
                    
                    // If "Favorites" is selected, pre-fill selectedBrandIds with wishlist brands
                    if self.selectedProductOption == "Favorites" {
                        self.selectedBrandIds = self.wishlistBrandIds
                    } else {
                        self.selectedBrandIds.removeAll() // Ensure clean slate for "All"
                    }
                    
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch brands: \(error.localizedDescription)")
            }
        }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupOverlay() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Dimmed background

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        // Setting up scrollView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])

        // Content view setup
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        // Setting contentView constraints within scrollView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensures horizontal scroll is disabled
        ])
    }
    
    private func setupFilters() {
        let productLabel = createSectionLabel(text: "All Brands")
        
        let productAll = createRadioButton(title: "All", selector: #selector(productOptionChanged(_:)))
        let productFavorites = createRadioButton(title: "Favorites", selector: #selector(productOptionChanged(_:)))
        
        let productStack = createHorizontalStack(views: [productAll, productFavorites])
        
        let stack = UIStackView(arrangedSubviews: [productLabel, productStack])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
        // Set "All" as the default selected
        selectedProductOption = "All"
        updateRadioButtons(in: stack, selectedOption: selectedProductOption)
        filteredBrands = brands
        collectionView?.reloadData()
    }

    // Modify the createRadioButton method
    private func createRadioButton(title: String, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .selected)
        button.tintColor = .red
        button.contentHorizontalAlignment = .left
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 8)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.tag = title == "All" ? 1 : 2 // 1 for All, 2 for Favorites
        return button
    }
    
    @objc func productOptionChanged(_ sender: UIButton) {
        selectedProductOption = sender.title(for: .normal) ?? "All"
        
        if selectedProductOption == "Favorites" {
            collectionView.isUserInteractionEnabled = true
            wishlistBrandIds = Set(wishlistBrands.map { "\($0.mbrandID)" })
            selectedBrandIds = wishlistBrandIds
        } else {
            selectedBrandIds.removeAll() // Clear selection for "All"
            collectionView.isUserInteractionEnabled = false
        }
        
        filteredBrands = brands
        collectionView.reloadData() // Update the collection view

        // Update radio buttons visually
        if let stackView = sender.superview?.superview {
            updateRadioButtons(in: stackView, selectedOption: selectedProductOption)
        }
    }

    // Improved updateRadioButtons method
    func updateRadioButtons(in stackView: UIView, selectedOption: String) {
        for case let button as UIButton in stackView.subviews.flatMap({ $0.subviews }) {
            let isSelected = button.title(for: .normal) == selectedOption
            button.setImage(UIImage(systemName: isSelected ? "largecircle.fill.circle" : "circle"), for: .normal)
        }
    }

    private func createSectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Roboto-Medium", size: 16)
        return label
    }
    
    private func createHorizontalStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .horizontal
        stack.spacing = 30
        stack.distribution = .fillEqually
        return stack
    }
    
    private func setupCollectionView() {
        
        // Configure the CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width / 7 + 10  , height: 63)
        layout.minimumLineSpacing = 10
        
        // Initialize CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "BrandCell")
        contentView.addSubview(collectionView)
        
        // Apply Constraints
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 450)
        ])
    }
    
    private func setupBottomButtons() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Cancel", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        closeButton.layer.cornerRadius = 4
        closeButton.backgroundColor = .customRed
        closeButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        let applyButton = UIButton(type: .system)
        applyButton.setTitle("Apply", for: .normal)
        applyButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = .customBlue
        applyButton.layer.cornerRadius = 4
        applyButton.addTarget(self, action: #selector(applyFilters), for: .touchUpInside)
        
        let buttonStack = UIStackView(arrangedSubviews: [closeButton, applyButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func dismissView() {
        dismissAction?()
    }
    
    @objc private func applyFilters() {
         if selectedProductOption == "All" && selectedBrandIds.isEmpty {
            selectedBrandIds.removeAll()
            self.endChar = ""
        }
        
        let brandIdArray = selectedBrandIds.joined(separator: ",")
        print("Selected Brands: \(brandIdArray)") // For debugging
        
        // Notify the delegate (ShopViewController)
        delegate?.didApplyFilter(selectedBrandIds: selectedBrandIds , endchar: endChar)
    }
}

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource, BrandCell.BrandCellDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredBrands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
        let brand = filteredBrands[indexPath.item]
        
        // Determine if this brand is selected
        let isSelected = selectedBrandIds.contains("\(brand.mbrandID)")
        
        // Determine if this brand is a favorite (exists in wishlistBrands)
        let isFavorite = wishlistBrands.contains { $0.mbrandID == brand.mbrandID }
        
        // Configure the cell with brand data, selection state, and favorite status
        cell.configure(with: brand, isSelected: isSelected, isFavorite: (selectedProductOption == "Favorites" && isFavorite))
        cell.delegate = self
        return cell
    }
    
    // BrandCellDelegate methods
    func didSelectBrand(withId brandId: String) {
            if selectedBrandIds.contains(brandId) {
                // If it's a wishlist brand, remove from both sets
                selectedBrandIds.remove(brandId)
                wishlistBrandIds.remove(brandId)
            } else {
                // Add the selected brand
                selectedBrandIds.insert(brandId)
            }
        
        print("Selected Brand IDs: \(selectedBrandIds)")
        print("Wishlist Brand IDs: \(wishlistBrandIds)")
        updateCellSelection(forBrandId: brandId)
    }
    
    func didDeselectBrand(withId brandId: String) {
        // Prevent deselection of wishlist brands
     //   if selectedProductOption == "Favorites" {
            if wishlistBrands.contains(where: { "\($0.mbrandID)" == brandId }) {
                wishlistBrandIds.remove(brandId)
                selectedBrandIds.remove(brandId)
                return
            }
       // }
        selectedBrandIds.remove(brandId)
        updateCellSelection(forBrandId: brandId)
    }
    
    
    // Helper method to reload only the tapped cell
    private func updateCellSelection(forBrandId brandId: String) {
        if let index = filteredBrands.firstIndex(where: { "\($0.mbrandID)" == brandId }) {
            let indexPath = IndexPath(item: index, section: 0)
            if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
}


import UIKit

class FilterCell: UICollectionViewCell {
    static let identifier = "FilterCell"
    
    private let checkBox: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .green
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    var isChecked = false {
        didSet {
            checkBox.isSelected = isChecked
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(checkBox)
        contentView.addSubview(titleLabel)
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        checkBox.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
    }
    
    @objc private func toggleSelection() {
        isChecked.toggle()
    }
    
    func configure(with title: String, selected: Bool) {
        titleLabel.text = title
        isChecked = selected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

