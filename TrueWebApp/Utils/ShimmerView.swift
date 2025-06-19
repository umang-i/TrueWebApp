//
//  ShimmerView.swift
//  TrueWebApp
//
//  Created by Umang Kedan on 27/05/25.
//

import Foundation
import UIKit

class ShimmerView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        gradientLayer.colors = [
            UIColor.lightGray.withAlphaComponent(0.3).cgColor,
            UIColor.lightGray.withAlphaComponent(0.1).cgColor,
            UIColor.lightGray.withAlphaComponent(0.3).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0, 0.5, 1]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        startAnimating()
    }

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "shimmer")
    }
}

class ShimmerCell: UITableViewCell {
    private let shimmerView = ShimmerView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(shimmerView)

        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
          //  shimmerView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


import UIKit

class CustomLoaderView: UIView {
    
    private let backgroundContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 30
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        return v
    }()
    
    private let circleLayer = CAShapeLayer()
    private let rotationAnimationKey = "rotationAnimation"
    private let strokeAnimationKey = "strokeAnimation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        // Add white rounded container
        addSubview(backgroundContainer)
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundContainer.widthAnchor.constraint(equalToConstant: 60),
            backgroundContainer.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Add circleLayer to container
        backgroundContainer.layer.addSublayer(circleLayer)
        
        circleLayer.strokeColor = UIColor.systemBlue.cgColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 4
        circleLayer.lineCap = .round
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = backgroundContainer.bounds
        let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(3 * Double.pi / 2)
        
        circleLayer.frame = bounds
        circleLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        ).cgPath
    }
    
    func startAnimating() {
        isHidden = false

        if circleLayer.animation(forKey: rotationAnimationKey) == nil {
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.fromValue = 0
            rotation.toValue = 2 * Double.pi
            rotation.duration = 1
            rotation.repeatCount = .infinity
            circleLayer.add(rotation, forKey: rotationAnimationKey) // ✅ FIXED
        }

        if circleLayer.animation(forKey: strokeAnimationKey) == nil {
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            strokeStart.fromValue = 0
            strokeStart.toValue = 0.25
            strokeStart.duration = 0.5
            strokeStart.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            strokeStart.autoreverses = true
            strokeStart.repeatCount = .infinity

            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
            strokeEnd.fromValue = 0
            strokeEnd.toValue = 1
            strokeEnd.duration = 0.5
            strokeEnd.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            strokeEnd.autoreverses = true
            strokeEnd.repeatCount = .infinity

            circleLayer.add(strokeStart, forKey: "strokeStartAnimation")
            circleLayer.add(strokeEnd, forKey: strokeAnimationKey)
        }
    }
    
    func stopAnimating() {
        circleLayer.removeAllAnimations()
        isHidden = true
    }

}

import UIKit

class ShimmerBannerCell: UICollectionViewCell {
    private let shimmerView = ShimmerView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        shimmerView.layer.cornerRadius = 10
        shimmerView.clipsToBounds = true
        
        contentView.addSubview(shimmerView)

        NSLayoutConstraint.activate([
            shimmerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shimmerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            shimmerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shimmerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        shimmerView.startAnimating()
    }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            shimmerView.startAnimating()
        } else {
            shimmerView.stopAnimating()
        }
    }
}
