import UIKit
import Lottie

class OrderConfirmationViewController: UIViewController {
    private var animationView: LottieAnimationView!
    private let continueButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Setup Lottie animation
        animationView = LottieAnimationView(name: "success")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
        
        // Continue Shopping Button
        continueButton.setTitle("CONTINUE SHOPPING", for: .normal)
        continueButton.backgroundColor = .customBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        continueButton.layer.cornerRadius = 4
        continueButton.addTarget(self, action: #selector(continueShoppingTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Lottie Animation View
            animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            animationView.heightAnchor.constraint(equalToConstant: 400),
            animationView.centerXAnchor.constraint(equalToSystemSpacingAfter: view.centerXAnchor, multiplier: 1),
            
            // Continue Button
            continueButton.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 380),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func continueShoppingTapped() {
        print("Continue Shopping tapped!")
        DispatchQueue.main.async {
            CartManager.shared.clearCart()
            ApiService().updateCartOnServer { success, errorMessage in
                DispatchQueue.main.async {
                    if success {
                        print("Cart successfully updated on server.")
                    } else {
                        print("Failed to update cart:", errorMessage ?? "Unknown error")
                    }
                }
            }
        }
        
        if let nav = self.navigationController,
           let tabBarVC = nav.viewControllers.first(where: { $0 is TabBarController }) {
            nav.popToViewController(tabBarVC, animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
