//
//  LoginModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

import Foundation

struct LogInModel: Encodable {
    let email: String
    let password: String

    enum CodingKeys: String, CodingKey {
        case email
        case password
    }
}

struct RegisterModel: Codable {
    let first_name: String
    let last_name: String
    let email: String
    let password: String
    let mobile: String
    let rep_code: String
    let company_name: String
    let address1: String
    let address2: String
    let city: String
    let country: String
    let postcode: String
}

struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let token: String
    let token_type: String
    let user: User1
    let expires_in: Double // Changed to Double for large value
}

struct User1: Codable {
    let id: Int
    let name: String
    let email: String
    let email_verified_at: String?
    let mobile: String
    let company_name: String
    let address1: String
    let address2: String? // Optional as it may be null
    let city: String
    let country: String
    let postcode: String
    let rep_code: String?
    let admin_approval: String // Changed to String because JSON returns "Approved"
    let created_at: String
    let updated_at: String
}


