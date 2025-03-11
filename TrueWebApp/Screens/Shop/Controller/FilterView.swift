//
//  FilterView.swift
//  TrueApp
//
//  Created by Umang Kedan on 07/03/25.
//
import UIKit

class FilterView: UIView {
    
    var collectionView: UICollectionView!
    var selectedBrands: Set<String> = []
    
    let brands = ["Additional POS", "Airheads", "Airplane", "Al Fakher", "Aspire Gotek",
                  "Bar Juice 5000", "Bebeto", "Blackfriars", "Candy Break", "Canabar",
                  "Chupa Chups", "Crystal Clear", "D&K", "Duracell", "Edge", "Elements",
                  "ELFA Pro", "Energizer", "Fanta", "Goat", "Gold Bar", "Hayati", "Hot Chip",
                  "Jelly Rose", "JUUL", "Kit Kat", "Like Home", "Lost Mary BM6000", "IVG"]
    
    var selectedProductOption: String = "All"
    var selectedStockOption: String = "All"

    
    private let contentView = UIView()
    
    var dismissAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupOverlay()
        setupFilters()
        setupCollectionView()
        setupBottomButtons()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupOverlay() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Dimmed background
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 4
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func setupFilters() {
        let productLabel = createSectionLabel(text: "Products")
        let productAll = createRadioButton(title: "All", selector: #selector(productOptionChanged(_:)))
        let productFavorites = createRadioButton(title: "Favorites", selector: #selector(productOptionChanged(_:)))
        let productStack = createHorizontalStack(views: [productAll, productFavorites])
        
        let stockLabel = createSectionLabel(text: "Stock")
        let stockAll = createRadioButton(title: "All", selector: #selector(stockOptionChanged(_:)))
        let stockInStock = createRadioButton(title: "In Stock Only", selector: #selector(stockOptionChanged(_:)))
        let stockStack = createHorizontalStack(views: [stockAll, stockInStock])
        
        let stack = UIStackView(arrangedSubviews: [productLabel, productStack, stockLabel, stockStack])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
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
        // Create the "Brands" header label
        let brandsLabel = UILabel()
        brandsLabel.text = "Brands"
        brandsLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        brandsLabel.textColor = .black
        brandsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(brandsLabel)
        
        // Configure the CollectionView Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: frame.width / 4 + 20  , height: 100)
        layout.minimumLineSpacing = 10
        
        // Initialize CollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "BrandCell")
        contentView.addSubview(collectionView)
        
        // Apply Constraints
        NSLayoutConstraint.activate([
            brandsLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 170),
            brandsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: brandsLabel.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 320)
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
        buttonStack.backgroundColor = .white
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func dismissView() {
        dismissAction?()
    }
    
    @objc private func applyFilters() {
        print("Filters applied: \(selectedBrands)")
        dismissView()
    }
    
    func createRadioButton(title: String, selector: Selector) -> UIView {
        let container = UIStackView()
        container.axis = .horizontal
        container.spacing = 8
        container.alignment = .center
        container.isUserInteractionEnabled = true

        // Circle Image View as a radio button
        let circleImageView = UIImageView()
        circleImageView.image = UIImage(systemName: "circle")
        circleImageView.tintColor = .red
        circleImageView.contentMode = .scaleAspectFit
        circleImageView.layer.cornerRadius = 12
        circleImageView.layer.borderColor = UIColor.red.cgColor
        circleImageView.clipsToBounds = true
        circleImageView.tag = 100 // Tag for updates

        // Button for selecting
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: selector, for: .touchUpInside)

        container.addArrangedSubview(circleImageView)
        container.addArrangedSubview(button)

        // Constraints for circle image
        NSLayoutConstraint.activate([
            circleImageView.widthAnchor.constraint(equalToConstant: 24),
            circleImageView.heightAnchor.constraint(equalToConstant: 24)
        ])

        // Tap gesture for entire row
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(radioButtonTapped(_:)))
        container.addGestureRecognizer(tapGesture)

        return container
    }
    
    @objc func productOptionChanged(_ sender: UIButton) {
        selectedProductOption = sender.title(for: .normal) ?? "All"
        updateRadioButtons(in: sender.superview!.superview!, selectedOption: selectedProductOption)
    }
    
    @objc func stockOptionChanged(_ sender: UIButton) {
        selectedStockOption = sender.title(for: .normal) ?? "All"
        updateRadioButtons(in: sender.superview!.superview!, selectedOption: selectedStockOption)
    }
    
    @objc func clearAllFilters() {
        selectedBrands.removeAll()
        collectionView.reloadData()
    }
  
    func updateRadioButtons(in stackView: UIView, selectedOption: String) {
        for case let container as UIStackView in stackView.subviews {
            guard let button = container.arrangedSubviews.last as? UIButton,
                  let circleImageView = container.arrangedSubviews.first as? UIImageView else { continue }

            let isSelected = button.title(for: .normal) == selectedOption
            circleImageView.image = UIImage(systemName: isSelected ? "largecircle.fill.circle" : "circle")
            circleImageView.tintColor = isSelected ? .red : .lightGray
            circleImageView.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.lightGray.cgColor
        }
    }

    // **New Function to Handle Tap Gesture**
    @objc func radioButtonTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? UIStackView,
              let button = tappedView.arrangedSubviews.last as? UIButton,
              let title = button.title(for: .normal) else { return }
        
        updateRadioButtons(in: tappedView.superview!, selectedOption: title)
    }
}

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brands.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
        let brand = brands[indexPath.item] // ✅ Fix: Retrieve brand correctly
        
        let isSelected = selectedBrands.contains(brand) // ✅ Now `brand` is defined
        cell.setSelectedState(isSelected: isSelected) // ✅ Update border color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brand = brands[indexPath.item]
        
        // Toggle selection
        if selectedBrands.contains(brand) {
            selectedBrands.remove(brand)
        } else {
            selectedBrands.insert(brand)
        }
        
        // Reload only the selected cell instead of the entire collection view
        collectionView.reloadItems(at: [indexPath])
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

