//
//  CompanyModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 06/06/25.
//

import Foundation

struct CompanyAddressResponse: Codable {
    let status: Bool
    let message: String
    let company_addresses: [CompanyAddress]?
}

struct CompanyAddress: Codable {
    let user_company_address_id: Int
    let user_id: Int
    let user_company_name: String
    let company_address1: String
    let company_address2: String?
    let company_city: String
    let company_country: String
    let company_postcode: String
    let created_at: String
    let updated_at: String
}
