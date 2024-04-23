//
//  EmptyStateView.swift
//  Eczane
//
//  Created by Emir Öztürk on 21.03.2024.
//

import UIKit

class EmptyStateView: UIView {
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .init(white: 1, alpha: 0.8)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.text = "Kayıtlı bir adres bulunamadı! Kayıt eklemek için sayfanın sağ üstünde bulunan + butonunundan ekleyiniz."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageLabel)
    }
    override func layoutSubviews() {
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        let messageLabelConstraints = [
            //messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageLabel.heightAnchor.constraint(equalToConstant: 350)
        ]
        
        NSLayoutConstraint.activate(messageLabelConstraints)
    }
}
