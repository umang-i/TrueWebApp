//
//  UIImage + extension.swift
//  
//
//  Created by Umang Kedan on 12/05/25.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(named: "noImage") // Default placeholder
                }
            }
        }
    }
}
