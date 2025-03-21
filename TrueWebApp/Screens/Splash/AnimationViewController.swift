//
//  AnimationViewController.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 20/03/25.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet weak var imgTextLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animateLogo()
        }
    }

    private func animateLogo() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .calculationModeLinear, animations: {
               
               // Scale up image (expanding effect)
               UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                   let scale = CGAffineTransform(scaleX: 5, y: 5) // Expand 5x
                   self.myImageView.transform = scale
                   self.imgTextLabel.alpha = 0
               }
               
               // Fade out image smoothly
               UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                   self.myImageView.alpha = 0
               }
               
           }, completion: { done in
               if done {
                   DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                       let loginVC = LoginController(nibName: "LoginController", bundle: nil)
                       self.navigationController?.pushViewController(loginVC, animated: true)
                   }
               }
           })
       }
}
