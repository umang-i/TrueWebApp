//
//  SplashScreen.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 26/03/25.
//

import UIKit
import SDWebImage

class SplashScreen: UIViewController {

    let gifImageView: SDAnimatedImageView = {
        let imageView = SDAnimatedImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(gifImageView)

        NSLayoutConstraint.activate([
            gifImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gifImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gifImageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            gifImageView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])

        playGIF(named: "splashGif")

        // Navigate after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.navigateToMainScreen()
        }
    }

    private func playGIF(named name: String) {
        if let path = Bundle.main.path(forResource: name, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            gifImageView.sd_setImage(with: url)
        }
    }

    private func navigateToMainScreen() {
        let defaults = UserDefaults.standard
        if let authToken = defaults.string(forKey: "authToken"), !authToken.isEmpty {
            let dashboardVC = TabBarController()
            navigationController?.pushViewController(dashboardVC, animated: true)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            let loginController = LoginController()
            self.navigationController?.pushViewController(loginController, animated: true)
        }
    }
}


//class SplashScreen: UIViewController {
//    
//    let logoImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(named: "logo1")) // Ensure "logo" is in Assets.xcassets
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    let smartSolutionsLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Smart Solutions"
//        label.textColor = .customBlue
//        label.font = UIFont(name: "Roboto-Medium", size: 30)
//        label.textAlignment = .center
//        label.alpha = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.white
//        
//        view.addSubview(logoImageView)
//        view.addSubview(smartSolutionsLabel)
//        
//        // Correct Constraints (Setting an initial small size)
//        NSLayoutConstraint.activate([
//            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            logoImageView.widthAnchor.constraint(equalToConstant: 125),
//            logoImageView.heightAnchor.constraint(equalToConstant: 125),
//            
//            smartSolutionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            smartSolutionsLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 140)
//        ])
//        
//        animateLogoAndText()
//    }
//    
//    func animateLogoAndText() {
//        // Animate logo expansion properly
//        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
//            self.logoImageView.transform = CGAffineTransform(scaleX: 2, y: 2) // Expands from original size
//        }) { _ in
//            // Animate text slide-up
//            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
//                self.smartSolutionsLabel.alpha = 1 // Fade in
//                self.smartSolutionsLabel.transform = CGAffineTransform(translationX: 0, y: -100) // Move up
//            }) { _ in
//                // Navigate to Home Screen after animation
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//                    self.navigateToMainScreen()
//                }
//            }
//        }
//    }
//    
//    private func navigateToMainScreen() {
//        // Check if authToken exists in UserDefaults
//        let defaults = UserDefaults.standard
//        if let authToken = defaults.string(forKey: "authToken"), !authToken.isEmpty {
//            // Navigate to Dashboard if authToken exists
//            let dashboardVC = TabBarController() // Your Dashboard screen
//            navigationController?.pushViewController(dashboardVC, animated: true)
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//        } else {
//            let loginController = LoginController()
//            self.navigationController?.pushViewController(loginController, animated: true)
//        }
//    }
//
//}
