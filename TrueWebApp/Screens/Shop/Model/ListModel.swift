//
//  ListModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 12/03/25.
//

import Foundation

// MARK: - Root Model
struct APIResponse: Codable {
    let success: Int
    let brands: [Brand]
    let categories: [Category]
}

// MARK: - Brand Model
struct Brand: Codable {
    let bra_id: Int
    let bra_title: String
}

// MARK: - Product Model
struct Product: Codable, Hashable {
    let sku: String
    let title: String
    let img: String
    let price: String
    let stock: Int
}

// MARK: - Subcategory Model
struct Subcategory: Codable {
    let id: Int
    let title: String
    let products: [Product]
   // var isExpanded: Bool = false
}

// MARK: - Category Model
struct Category: Codable {
    let id: Int
    let title: String
    var subCats: [Subcategory]
   // var isExpanded: Bool = false
}

func loadCategoriesFromJSON() -> [Category]? {
    guard let path = Bundle.main.path(forResource: "categories", ofType: "json") else {
        print("JSON file not found")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return apiResponse.categories
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
