//
//  RepModel.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 26/06/25.
//

import Foundation

struct RepCheckResponse: Codable {
    let status: Bool
    let data: RepData?
}

struct RepData: Codable {
    let repID: Int
    let userID: Int
    let repCode: String
    let commissionPercent: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case repID = "rep_id"
        case userID = "user_id"
        case repCode = "rep_code"
        case commissionPercent = "commission_percent"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
