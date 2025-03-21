//
//  SplashController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 20/03/25.
//

import Foundation

import UIKit

class SplashViewController: UIViewController {
    
    // Animated ImageView
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "splash")) // Change to your image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0 // Start with transparency
        return imageView
    }()

    // Animated Text (e.g., App Name or Slogan)
    private let animatedTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to MyApp" // Change to your text
        label.font = UIFont(name: "Roboto-Bold", size: 20)
        label.textColor = .black
        label.textAlignment = .center
        label.alpha = 0 // Start hidden
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add subviews
        view.addSubview(logoImageView)
        view.addSubview(animatedTextLabel)
        
        // Layout constraints
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        animatedTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Center the image
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 300),
            logoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Position the text below the image
            animatedTextLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedTextLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20)
        ])
        
        // Start animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.animateLogo()
        }
    }
    
    private func animateLogo() {
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.logoImageView.alpha = 1 // Fade in
            self.logoImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Scale up
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImageView.transform = .identity // Return to original size
            }) { _ in
                self.animateText()
            }
        }
    }
    
    private func animateText() {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
            self.animatedTextLabel.alpha = 1 // Fade-in text
        }) { _ in
            self.typeWriterEffect()
        }
    }

    private func typeWriterEffect() {
        let text = "Welcome to MyApp"
        animatedTextLabel.text = ""
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if index < text.count {
                let indexStart = text.index(text.startIndex, offsetBy: index)
                self.animatedTextLabel.text?.append(text[indexStart])
                index += 1
            } else {
                timer.invalidate()
                self.navigateToMainScreen()
            }
        }
    }

    private func navigateToMainScreen() {
        let mainVC = LoginController() // Change to your main screen
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
