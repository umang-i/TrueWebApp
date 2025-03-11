//
//  MethodDeliveryCell.swift
//  TrueApp
//
//  Created by Umang Kedan on 07/03/25.
//

import UIKit

protocol MethodDeliveryCellDelegate: AnyObject {
    func didSelectDeliveryOption(_ cell: MethodDeliveryCell)
}

class MethodDeliveryCell: UITableViewCell {

    weak var delegate: MethodDeliveryCellDelegate?

    private let outerCircle: UIView = {
            let view = UIView()
            view.layer.borderColor = UIColor.gray.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        private let innerCircle: UIView = {
            let view = UIView()
            view.backgroundColor = .gray
            view.layer.cornerRadius = 4
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Regular", size: 14)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupTapGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(outerCircle)
        outerCircle.addSubview(innerCircle)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            outerCircle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            outerCircle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            outerCircle.widthAnchor.constraint(equalToConstant: 20),
            outerCircle.heightAnchor.constraint(equalToConstant: 20),
            
            innerCircle.centerXAnchor.constraint(equalTo: outerCircle.centerXAnchor),
            innerCircle.centerYAnchor.constraint(equalTo: outerCircle.centerYAnchor),
            innerCircle.widthAnchor.constraint(equalToConstant: 10),
            innerCircle.heightAnchor.constraint(equalToConstant: 10),
            
            titleLabel.leadingAnchor.constraint(equalTo: outerCircle.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
        ])
    }

    @objc private func radioButtonTapped() {
        delegate?.didSelectDeliveryOption(self)
    }

    func configure(with title: String, isSelected: Bool) {
        titleLabel.text = title
        updateRadioButton(isSelected: isSelected)
    }
    
    private func updateRadioButton(isSelected: Bool) {
        if isSelected {
            outerCircle.layer.borderColor = UIColor.customRed.cgColor
            innerCircle.backgroundColor = .customRed
            innerCircle.isHidden = false
        } else {
            outerCircle.layer.borderColor = UIColor.gray.cgColor
            innerCircle.backgroundColor = .gray
            innerCircle.isHidden = true
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func cellTapped() {
        delegate?.didSelectDeliveryOption(self)
    }
}
