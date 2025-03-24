//
//  AnimationViewController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 20/03/25.
//

import UIKit
import FLAnimatedImage

class AnimationViewController: UIViewController {

    let gifImageView = FLAnimatedImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGifView()
        navigateToLoginScreen()
    }

    func setupGifView() {
        // Ensure the GIF fills the screen
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.contentMode = .scaleAspectFill // Covers full screen
        gifImageView.clipsToBounds = true
        view.addSubview(gifImageView)
        
        // Apply constraints to make it full-screen
        NSLayoutConstraint.activate([
            gifImageView.topAnchor.constraint(equalTo: view.topAnchor),
            gifImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gifImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gifImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Load GIF
        if let path = Bundle.main.path(forResource: "splashGif", ofType: "gif"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let animatedImage = FLAnimatedImage(animatedGIFData: data)
            gifImageView.animatedImage = animatedImage
        } else {
            print("Error: GIF not found")
        }
    }

    func navigateToLoginScreen() {
        // Navigate to LoginScreen after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            let loginVC = LoginController(nibName: "LoginController", bundle: nil) // Replace with actual class name
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
