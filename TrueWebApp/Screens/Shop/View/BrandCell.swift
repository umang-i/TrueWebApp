//
//  BrandCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 11/03/25.
//

import UIKit

class BrandCell: UICollectionViewCell {
    
    protocol BrandCellDelegate: AnyObject {
        func didSelectBrand(withId brandId: String)
        func didDeselectBrand(withId brandId: String)
      //  func didToggleFavoriteState(forBrandWithId brandId: String)
    }
    
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var brandView: UIView!
    @IBOutlet weak var brandImageView: UIImageView!
    
    weak var delegate: BrandCellDelegate?
    var brandId: String? // Store the brand ID
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
        setupGestureRecognizers()
    }
    
    private func setupCellAppearance() {
        brandView.layer.cornerRadius = 10
        brandView.isUserInteractionEnabled = false
        
        // Image view styling
        brandImageView.backgroundColor = .yellow
        brandImageView.layer.cornerRadius = 10
        brandImageView.clipsToBounds = true
        
        // Checkmark styling
        checkmarkImageView.image = UIImage(named: "checkmark")?.withRenderingMode(.alwaysTemplate)
        checkmarkImageView.tintColor = .systemGreen
        checkmarkImageView.isHidden = true
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        tapGesture.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tapGesture)
    }
    
    func setSelectedState(isSelected: Bool) {
        checkmarkImageView.isHidden = !isSelected
    }
    
    func configure(with brand: Brand, isSelected: Bool, isFavorite: Bool) {
        self.brandId = "\(brand.mbrandID)"
        setImage(brand: brand)
        setSelectedState(isSelected: isSelected)
        
        // Favorite checkmark logic
        if isFavorite {
            // Show a green checkmark for favorite brands
            checkmarkImageView.isHidden = false
            checkmarkImageView.tintColor = .systemGreen
        } else {
            // Hide the checkmark for non-favorites unless selected
            checkmarkImageView.isHidden = !isSelected
            checkmarkImageView.tintColor = isSelected ? .systemGreen : .clear
        }
    }
    
    private func setImage(brand: Brand) {
         let imageUrlString = "https://cdn.truewebpro.com/\(brand.mbrandImage)"
           if let url = URL(string: imageUrlString) {
            brandImageView.load(url: url) // Use your custom image loading method
        } else {
            brandImageView.image = UIImage(named: "noImage") // Default placeholder
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error loading image from \(url): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            let fetchedImage = UIImage(data: data)
            completion(fetchedImage)
        }.resume()
    }
    
    @objc private func cellTapped() {
        guard let brandId = brandId else { return }

        if checkmarkImageView.isHidden {
            // If it's hidden, select the brand
            delegate?.didSelectBrand(withId: brandId)
        } else {
            // If it's shown, deselect the brand
            delegate?.didDeselectBrand(withId: brandId)
        }
        
        // Toggle the favorite state when the cell is tapped
        if checkmarkImageView.tintColor == .systemGreen {
            // If it is selected, toggle it
            checkmarkImageView.tintColor = .clear
            checkmarkImageView.isHidden = true
        } else {
            // If it's deselected, show the checkmark again
            checkmarkImageView.tintColor = .systemGreen
            checkmarkImageView.isHidden = false
        }
    }
}
