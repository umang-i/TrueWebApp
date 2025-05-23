//
//  MyCompanyController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class MyCompanyController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    var user_company_address_id : Int
    var companyName: String
    var addressLine1: String
    var addressLine2: String
    var city: String
    var county: String
    var postcode: String
    var num: Int

    var companyAddresses: [CompanyAddress]
    
    
    // MARK: - UI Elements
    let bannerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bnr1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var companyNameField = CustomTextField(placeholder: "Please enter company Name", text: companyName)
    private lazy var line1Field = CustomTextField(placeholder: "Please enter invoice address line 1", text: addressLine1)
    private lazy var line2Field = CustomTextField(placeholder: "Please enter invoice address line 2", text: addressLine2)
    private lazy var cityField = CustomTextField(placeholder: "Please enter invoice address city", text: city)
    private lazy var countyField = CustomTextField(placeholder: "Please enter invoice address county", text: county)
    private lazy var postcodeField = CustomTextField(placeholder: "Please enter invoice address postcode", text: postcode)

    let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        button.backgroundColor = UIColor.customRed
        button.layer.cornerRadius = 4
        button.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(updateCompanyTapped), for: .touchUpInside)
        return button
    }()

    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.backgroundColor = UIColor.customRed
        button.layer.cornerRadius = 4
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(deleteCompanyTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Initializer
    init( user_company_address_id : Int ,  companyName: String, addressLine1: String, addressLine2: String, city: String, county: String, postcode: String, num: Int, companyAddresses: [CompanyAddress]) {
        self.user_company_address_id = user_company_address_id
            self.companyName = companyName
            self.addressLine1 = addressLine1
            self.addressLine2 = addressLine2
            self.city = city
            self.county = county
            self.postcode = postcode
            self.num = num
            self.companyAddresses = companyAddresses
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateButton.setTitle(num == 1 ? "Update" : "Save", for: .normal)
        setupUI()
        setnavBar()
    }
    
    // MARK: - UI Setup
    
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: num == 0 ? "Add Address" : "Edit Address")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            // Background View Constraints (covers top of the screen)
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed

            // CustomNavBar Constraints
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupUI() {
        view.addSubview(bannerImageView)
        view.addSubview(companyNameField)
        view.addSubview(line1Field)
        view.addSubview(line2Field)
        view.addSubview(cityField)
        view.addSubview(countyField)
        view.addSubview(postcodeField)
        view.addSubview(updateButton)
        
        if num == 1 {
            view.addSubview(deleteButton)
        }

        [bannerImageView, companyNameField,
         line1Field, line2Field, cityField, countyField, postcodeField, updateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            bannerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 120),
            
            companyNameField.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 20),
            companyNameField.leadingAnchor.constraint(equalTo: bannerImageView.leadingAnchor , constant: 10),
            companyNameField.trailingAnchor.constraint(equalTo: bannerImageView.trailingAnchor , constant: -10),
            companyNameField.heightAnchor.constraint(equalToConstant: 60),
            
            line1Field.topAnchor.constraint(equalTo: companyNameField.bottomAnchor, constant: 10),
            line1Field.leadingAnchor.constraint(equalTo: companyNameField.leadingAnchor),
            line1Field.trailingAnchor.constraint(equalTo: companyNameField.trailingAnchor),
            line1Field.heightAnchor.constraint(equalToConstant:textFieldHeight),
            
            line2Field.topAnchor.constraint(equalTo: line1Field.bottomAnchor, constant: 10),
            line2Field.leadingAnchor.constraint(equalTo: line1Field.leadingAnchor),
            line2Field.trailingAnchor.constraint(equalTo: line1Field.trailingAnchor),
            line2Field.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            cityField.topAnchor.constraint(equalTo: line2Field.bottomAnchor, constant: 10),
            cityField.leadingAnchor.constraint(equalTo: line2Field.leadingAnchor),
            cityField.trailingAnchor.constraint(equalTo: line2Field.trailingAnchor),
            cityField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            countyField.topAnchor.constraint(equalTo: cityField.bottomAnchor, constant: 10),
            countyField.leadingAnchor.constraint(equalTo: cityField.leadingAnchor),
            countyField.trailingAnchor.constraint(equalTo: cityField.trailingAnchor),
            countyField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            postcodeField.topAnchor.constraint(equalTo: countyField.bottomAnchor, constant: 10),
            postcodeField.leadingAnchor.constraint(equalTo: countyField.leadingAnchor),
            postcodeField.trailingAnchor.constraint(equalTo: countyField.trailingAnchor),
            postcodeField.heightAnchor.constraint(equalToConstant: textFieldHeight),
            
            updateButton.topAnchor.constraint(equalTo: postcodeField.bottomAnchor, constant: 20),
            updateButton.leadingAnchor.constraint(equalTo: postcodeField.leadingAnchor),
            updateButton.trailingAnchor.constraint(equalTo: postcodeField.trailingAnchor),
            updateButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])

        if num == 1 {
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                deleteButton.topAnchor.constraint(equalTo: updateButton.bottomAnchor, constant: 15),
                deleteButton.leadingAnchor.constraint(equalTo: updateButton.leadingAnchor),
                deleteButton.trailingAnchor.constraint(equalTo: updateButton.trailingAnchor),
                deleteButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            ])
        }
    }

    @objc func updateCompanyTapped() {
        companyName = companyNameField.text ?? ""
        addressLine1 = line1Field.text ?? ""
        addressLine2 = line2Field.text ?? ""
        city = cityField.text ?? ""
        county = countyField.text ?? ""
        postcode = postcodeField.text ?? ""

        let updatedAddress: [String: Any] = [
            "user_company_address_id": user_company_address_id,
            "user_company_name": companyName,
            "company_address1": addressLine1,
            "company_address2": addressLine2,
            "company_city": city,
            "company_country": county,
            "company_postcode": postcode
        ]

        // Check if we're updating an existing address
        var updatedAddresses: [[String: Any]] = []
        var found = false

        for address in companyAddresses {
            if address.user_company_address_id == user_company_address_id {
                updatedAddresses.append(updatedAddress)
                found = true
            } else {
                updatedAddresses.append([
                    "user_company_address_id": address.user_company_address_id,
                    "user_company_name": address.user_company_name,
                    "company_address1": address.company_address1,
                    "company_address2": address.company_address2 ?? "",
                    "company_city": address.company_city,
                    "company_country": address.company_country,
                    "company_postcode": address.company_postcode
                ])
            }
        }

        // If not found, we're adding a new one
        if !found {
            updatedAddresses.append(updatedAddress)
        }

        let requestBody: [String: Any] = [
            "addresses": updatedAddresses
        ]

        ApiService().postCompanyAddresses(requestBody: requestBody) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Success:", response)
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                    self.showAlert(message: "Failed to update address: \(error.localizedDescription)")
                }
            }
        }
    }

    // Alert for Error Handling
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc func deleteCompanyTapped() {
        // Filter out the address to delete
        let updatedAddresses = companyAddresses.filter { $0.user_company_address_id != user_company_address_id }
            .map { address in
                return [
                    "user_company_address_id": address.user_company_address_id,
                    "user_company_name": address.user_company_name,
                    "company_address1": address.company_address1,
                    "company_address2": address.company_address2 ?? "",
                    "company_city": address.company_city,
                    "company_country": address.company_country,
                    "company_postcode": address.company_postcode
                ]
            }
        
        let requestBody: [String: Any] = [
            "addresses": updatedAddresses
        ]
        
        ApiService().postCompanyAddresses(requestBody: requestBody) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("Deleted address ID: \(self.user_company_address_id)")
                    self.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    print("Error:", error.localizedDescription)
                    self.showAlert(message: "Failed to delete address: \(error.localizedDescription)")
                }
            }
        }
    }
}
