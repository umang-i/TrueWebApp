//
//  TermsAndPrivacy.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 05/05/25.
//

import Foundation

struct PageContentResponse: Codable {
    let success: Bool
    let terms: Page
    let privacy: Page
}

struct Page: Codable {
    let pageId: Int
    let pageName: String
    let pageSlug: String
    let pageContent: String
    let pageStatus: String
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case pageId = "page_id"
        case pageName = "page_name"
        case pageSlug = "page_slug"
        case pageContent = "page_content"
        case pageStatus = "page_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

