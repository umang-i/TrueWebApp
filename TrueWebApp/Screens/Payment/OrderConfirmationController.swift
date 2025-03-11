import UIKit

class OrderConfirmationViewController: UIViewController {

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let continueButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Success Image
        imageView.image = UIImage(named: "order_confirmation")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Title Label
        titleLabel.text = "Order Placed Successfully!"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        // Subtitle Label
        subtitleLabel.text = "Your order has been placed successfully. Thank you for shopping with us!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 2
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subtitleLabel)

        // Continue Shopping Button
        continueButton.setTitle("CONTINUE SHOPPING", for: .normal)
        continueButton.backgroundColor = .customBlue
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        continueButton.layer.cornerRadius = 4
        continueButton.addTarget(self, action: #selector(continueShoppingTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)

        // Auto Layout Constraints
        NSLayoutConstraint.activate([
            // Image View
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 350), // Adjust height as needed

            // Title Label
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Subtitle Label
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Continue Button
            continueButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 380),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func continueShoppingTapped() {
        print("Continue Shopping tapped!")
        navigationController?.popViewController(animated: true)
    }
}

