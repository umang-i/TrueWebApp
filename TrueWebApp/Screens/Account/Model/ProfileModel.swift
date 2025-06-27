//
//  ProfileModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

struct UserProfileResponse: Codable {
    let status: Bool
    let user_detail: UserDetail
    let rep_details: RepDetaill?
}

struct UserDetail: Codable {
    let id: Int
    let rep_id: Int?
    let name: String
    let email: String
    let email_verified_at: String?
    let mobile: String
    let company_name: String
    let address1: String
    let address2: String?
    let city: String
    let country: String
    let postcode: String
    let admin_approval: String
    let created_at: String
    let updated_at: String
}

struct RepDetaill: Codable {
    let rep_id: Int
    let rep_code: String
    let user_id: Int
    let commission_percent: String
    let user: RepUser
}

struct RepUser: Codable {
    let id: Int
    let name: String
    let email: String
    let mobile: String
}
