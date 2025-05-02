//
//  LoginModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 24/04/25.
//

import Foundation

struct LogInModel: Codable {
    let email: String
    let password: String
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
    let user: Int
    let expires_in: Int
}


