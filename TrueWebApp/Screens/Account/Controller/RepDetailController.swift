//
//  RepDetailController.swift
//  TrueApp
//
//  Created by Umang Kedan on 20/02/25.
//

import UIKit

class RepDetailController: UIViewController, CustomNavBarDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }

    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var emailLabelText: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phonenumText: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
       
        emailLabelText.font = UIFont(name: "Roboto-Medium", size: 14)
            emailLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            phonenumText.font = UIFont(name: "Roboto-Medium", size: 14)
            phoneNoLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            userName.font = UIFont(name: "Roboto-Bold", size: 20)
        pictureImageView.layer.cornerRadius = pictureImageView.frame.height / 2
    }
    func setnavBar() {
        let topBackgroundView = UIView()
        topBackgroundView.backgroundColor = .white
        topBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBackgroundView)

        let navBar = CustomNavBar(text: "My Rep Details")
        navBar.delegate = self
        navBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navBar)

        NSLayoutConstraint.activate([
            // Background View Constraints (covers top of the screen)
            topBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            topBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 100), // Adjust height as needed

            // CustomNavBar Constraints
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
