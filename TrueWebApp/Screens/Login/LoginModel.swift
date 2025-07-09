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

struct LoginResponse: Codable {
    let status: Bool
    let message: String
    let token: String
    let token_type: String
    let user_detail: UserDetails
    let rep_details: RepDetail?  // nullable
    let expires_in: Double
}

struct UserDetails: Codable {
    let id: Int
    let rep_id: Int
    let name: String
    let email: String
    let email_verified_at: String?
    let mobile: String
    let company_name: String
    let address1: String
    let address2: String
    let city: String
    let country: String
    let postcode: String
    let admin_approval: String
    let created_at: String
    let updated_at: String
}

struct RepDetail: Codable {
    let rep_id: Int
    let name: String
    let email: String
    let mobile: String
    let rep_code: String
    let commission_percent: String

    enum CodingKeys: String, CodingKey {
        case rep_id, name, email, mobile, rep_code, commission_percent
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
