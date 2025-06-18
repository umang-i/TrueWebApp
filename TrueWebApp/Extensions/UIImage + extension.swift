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
            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        print("Image data invalid at URL:", url)
                        self?.image = UIImage(named: "noImage")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to load image from URL: \(url), error: \(error)")
                    self?.image = UIImage(named: "noImage")
                }
            }
        }
    }
}
