//
//  CustomTextFieldView.swift
//  Eczane
//
//  Created by Emir Öztürk on 22.03.2024.
//

import UIKit

class CustomTextField: UITextField {

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
            
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        
        textColor = .label
        tintColor = .label
        textAlignment = .center
        
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        
        backgroundColor = .tertiarySystemBackground
        autocorrectionType = .no
        returnKeyType = .done
        clearButtonMode = .whileEditing
        placeholder = "Hatırlamak istediğiniz adı giriniz."
    }
}
