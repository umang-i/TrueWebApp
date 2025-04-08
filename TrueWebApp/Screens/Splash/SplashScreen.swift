//
//  SplashScreen.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 26/03/25.
//

import UIKit

class SplashScreen: UIViewController {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo")) // Ensure "logo" is in Assets.xcassets
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let smartSolutionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Smart Solutions"
        label.textColor = .white
        label.font = UIFont(name: "Roboto-Medium", size: 30)
        label.textAlignment = .center
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 4/255, green: 30/255, blue: 73/255, alpha: 1) // Dark blue background
        
        view.addSubview(logoImageView)
        view.addSubview(smartSolutionsLabel)
        
        // Correct Constraints (Setting an initial small size)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 125),
            logoImageView.heightAnchor.constraint(equalToConstant: 125),
            
            smartSolutionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            smartSolutionsLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 140)
        ])
        
        animateLogoAndText()
    }
    
    func animateLogoAndText() {
        // Animate logo expansion properly
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.logoImageView.transform = CGAffineTransform(scaleX: 2, y: 2) // Expands from original size
        }) { _ in
            // Animate text slide-up
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.smartSolutionsLabel.alpha = 1 // Fade in
                self.smartSolutionsLabel.transform = CGAffineTransform(translationX: 0, y: -100) // Move up
            }) { _ in
                // Navigate to Home Screen after animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigateToMainScreen()
                }
            }
        }
    }
    
    private func navigateToMainScreen() {
        let mainVC = LoginController() // Change to your main screen
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
