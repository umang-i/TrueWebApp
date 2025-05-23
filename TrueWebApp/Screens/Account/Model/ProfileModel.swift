//
//  ProfileModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

import Foundation

struct UserProfileResponse: Codable {
    let status: Bool
    let user: User
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
    let email_verified_at: String?
    let mobile: String
    let company_name: String
    let address1: String
    let address2: String?
    let city: String?
    let country: String?
    let postcode: String?
    let rep_code: String?
    let created_at: String
    let updated_at: String
}

