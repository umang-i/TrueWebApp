//
//  RepModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 26/06/25.
//

import Foundation

struct RepResponse: Codable {
    let status: Bool
    let data: RepData
}

struct RepData: Codable {
    let repID: Int
    let name: String
    let email: String
    let mobile: String
    let repCode: String
    let commissionPercent: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case repID = "rep_id"
        case name
        case email
        case mobile
        case repCode = "rep_code"
        case commissionPercent = "commission_percent"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
