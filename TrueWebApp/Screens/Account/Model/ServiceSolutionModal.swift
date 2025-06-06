//
//  ServiceSolutionModal.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 06/06/25.
//

import Foundation

struct ServiceSolutionsResponse: Codable {
    let status: Bool
    let message: String
    let service_solutions: [ServiceSolution]
}

struct ServiceSolution: Codable {
    let service_solution_id: Int
    let service_solution_title: String
    let service_solution_sub_title: String
    let service_solution_image: String
    let service_solution_desc: String
}
