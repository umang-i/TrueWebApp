//
//  PasswordModal.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 06/06/25.
//

import Foundation

struct Password : Encodable {
    var current_password : String
    var new_password : String
    var new_password_confirmation : String
}
