//
//  ShopModel.swift
//  TrueApp
//
//  Created by Umang Kedan on 03/03/25.
import Foundation

import Foundation

// MARK: - API Response
struct APIResponseCat: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let mainCategories: [MainCategory]
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case cdnURL
        case mainCategories = "main_categories"
    }
}

struct MainCategory: Codable {
    let mainMcatID: Int
    let mainMcatName: String
    let createdAt: String
    let updatedAt: String
    let categories: [Categoryy]?

    enum CodingKeys: String, CodingKey {
        case mainMcatID = "main_mcat_id"
        case mainMcatName = "main_mcat_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categories
    }
}

// MARK: - Category
struct Categoryy: Codable {
    let mcat_id: Int
    let mcat_name: String
    let created_at: String
    let updated_at: String
    let subcategories: [Subcat]

    var isExpanded: Bool = false

    private enum CodingKeys: String, CodingKey {
        case mcat_id, mcat_name, created_at, updated_at, subcategories
    }
}

// MARK: - Subcategory
struct Subcat: Codable {
    let msubcat_id: Int
    let mcat_id: Int
    let msubcat_name: String
    let msubcat_slug: String
    let msubcat_tag: String?
    let msubcat_image: String
    let msubcat_publish: String
    let offer_name: String?
    let start_time: String?
    let end_time: String?
    let msubcat_type: String
    let product_ids: [Int]
    let created_at: String
    let updated_at: String
    let products: [Products]

    var isExpanded: Bool = false

    private enum CodingKeys: String, CodingKey {
        case msubcat_id, mcat_id, msubcat_name, msubcat_slug, msubcat_tag,
             msubcat_image, msubcat_publish, msubcat_type,
             product_ids, created_at, updated_at, products,
             offer_name, start_time, end_time
    }

    // Custom Decoder to handle msubcat_publish as String or Array
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        msubcat_id = try container.decode(Int.self, forKey: .msubcat_id)
        mcat_id = try container.decode(Int.self, forKey: .mcat_id)
        msubcat_name = try container.decode(String.self, forKey: .msubcat_name)
        msubcat_slug = try container.decode(String.self, forKey: .msubcat_slug)
        msubcat_tag = try? container.decode(String?.self, forKey: .msubcat_tag)
        msubcat_image = try container.decode(String.self, forKey: .msubcat_image)

        if let publishString = try? container.decode(String.self, forKey: .msubcat_publish) {
            msubcat_publish = publishString
        } else if let publishArray = try? container.decode([String].self, forKey: .msubcat_publish) {
            msubcat_publish = publishArray.joined(separator: ", ")
        } else {
            msubcat_publish = ""
        }

        offer_name = try? container.decode(String?.self, forKey: .offer_name)
        start_time = try? container.decode(String?.self, forKey: .start_time)
        end_time = try? container.decode(String?.self, forKey: .end_time)
        msubcat_type = try container.decode(String.self, forKey: .msubcat_type)
        product_ids = try container.decode([Int].self, forKey: .product_ids)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)
        products = try container.decode([Products].self, forKey: .products)
    }
}

// MARK: - Product
struct Products: Codable, Hashable {
    let mproduct_id: Int
    let mproduct_title: String
    let mproduct_image: String? // Optional to handle null values
    let mproduct_slug: String
    let mproduct_desc: String?
    let status: String
    let saleschannel: [String]
    let product_type: String?
    let product_deal_tag: String?
    let product_offer: String?
    let brand_name: String?
    let mvariant_id: Int
    let sku: String
    let image: String?
    let price: Double
    let compare_price: Double?
    let cost_price: Double?
    let taxable: Int
    let barcode: String?
    let options: [String]?
    let option_value: [String : String]?
    let quantity: Int?
    let mlocation_id: Int
    var user_info_wishlist: Bool
    
    enum CodingKeys: String, CodingKey {
        case mproduct_id, mproduct_title, mproduct_image, mproduct_slug, mproduct_desc, status
        case saleschannel, product_type, product_deal_tag, product_offer, brand_name,quantity
        case mvariant_id, sku, image, price, compare_price, cost_price, taxable, barcode
        case options, option_value, mlocation_id, user_info_wishlist
    }

    // Custom Decoder with Safe Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        mproduct_id = try container.decode(Int.self, forKey: .mproduct_id)
        mproduct_title = try container.decode(String.self, forKey: .mproduct_title)
        mproduct_image = try? container.decodeIfPresent(String.self, forKey: .mproduct_image) // Null-safe
        mproduct_slug = try container.decode(String.self, forKey: .mproduct_slug)
        mproduct_desc = try? container.decodeIfPresent(String.self, forKey: .mproduct_desc)
        status = try container.decode(String.self, forKey: .status)
        
        // Safe decoding for saleschannel (String or Array)
        if let channelArray = try? container.decode([String].self, forKey: .saleschannel) {
            saleschannel = channelArray
        } else if let channelString = try? container.decode(String.self, forKey: .saleschannel) {
            saleschannel = [channelString]
        } else {
            saleschannel = []
        }

        product_type = try? container.decodeIfPresent(String.self, forKey: .product_type)
        product_deal_tag = try? container.decodeIfPresent(String.self, forKey: .product_deal_tag)
        product_offer = try? container.decodeIfPresent(String.self, forKey: .product_offer)
        brand_name = try? container.decodeIfPresent(String.self, forKey: .brand_name)
        mvariant_id = try container.decode(Int.self, forKey: .mvariant_id)
        sku = try container.decode(String.self, forKey: .sku)
        image = try? container.decodeIfPresent(String.self, forKey: .image)
        price = try container.decode(Double.self, forKey: .price)
        compare_price = try? container.decodeIfPresent(Double.self, forKey: .compare_price)
        cost_price = try? container.decodeIfPresent(Double.self, forKey: .cost_price)
        taxable = try container.decode(Int.self, forKey: .taxable)
        barcode = try? container.decodeIfPresent(String.self, forKey: .barcode)
        options = try? container.decodeIfPresent([String].self, forKey: .options)
        option_value = try? container.decodeIfPresent([String: String].self, forKey: .option_value)
        quantity = try? container.decode(Int.self, forKey: .quantity)
        mlocation_id = try container.decode(Int.self, forKey: .mlocation_id)
        user_info_wishlist = try container.decode(Bool.self, forKey: .user_info_wishlist)
    }
}

// MARK: - Response
struct BrowseBannerResponse: Codable {
    let status: Bool
    let message: String
    let cdnURL: String
    let browseBanners: [BrowseBanner]

    enum CodingKeys: String, CodingKey {
        case status, message
        case cdnURL
        case browseBanners
    }
}

struct BrowseBanner: Codable {
    let browsebannerId: Int?
    let browsebannerName: String?
    let browsebannerImage: String?
    let browsebannerPosition: Int?
    let mainMcatId: Int?
    let mcatId: Int?
    let msubcatId: Int?
    let mproductId: Int?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case browsebannerId       = "browsebanner_id"
        case browsebannerName     = "browsebanner_name"
        case browsebannerImage    = "browsebanner_image"
        case browsebannerPosition = "browsebanner_position"
        case mainMcatId           = "main_mcat_id"
        case mcatId               = "mcat_id"
        case msubcatId            = "msubcat_id"
        case mproductId           = "mproduct_id"
        case createdAt            = "created_at"
        case updatedAt            = "updated_at"
    }
}


import Foundation

enum NetworkError: Error {
    case invalidURL
    case missingUserId
    case noData
    case badStatusCode(Int)
    case apiError(String)
}

// MARK: - Brand Response
struct Brand: Decodable {
    let mbrandID: Int
    let mbrandName: String
    let mbrandImage: String
    
    enum CodingKeys: String, CodingKey {
        case mbrandID = "mbrand_id"
        case mbrandName = "mbrand_name"
        case mbrandImage = "mbrand_image"
    }
}

struct BrandResponse: Decodable {
    let status: Bool
    let message: String
    let cdnURL: String
    let mbrands: [Brand]
    let wishlistbrand : [Brand]
}


extension Products {
    init(
        mproduct_id: Int,
        mproduct_title: String,
        price: Double
    ) {
        self.mproduct_id = mproduct_id
        self.mproduct_title = mproduct_title
        self.mproduct_image = nil
        self.mproduct_slug = ""
        self.mproduct_desc = nil
        self.status = ""
        self.saleschannel = []
        self.product_type = nil
        self.product_deal_tag = nil
        self.product_offer = nil
        self.brand_name = nil
        self.mvariant_id = 0
        self.sku = ""
        self.image = nil
        self.price = price
        self.compare_price = nil
        self.cost_price = nil
        self.taxable = 0
        self.barcode = nil
        self.options = nil
        self.option_value = nil
        self.quantity = 0
        self.mlocation_id = 0
        self.user_info_wishlist = false
    }
}
