//
//  CustomTextField.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class CustomTextField {
    
    class func getTextField(withPlaceholder placeholder: String = "") -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.Value.cornerRadius
        field.addBorder(borderColor: UIColor.lightGray, widthBorder: 1.0)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.placeholder = placeholder
        if #available(iOS 13.0, *) {
            field.backgroundColor = .secondarySystemBackground
        } else {
            // Fallback on earlier versions
        }
        return field
    }
    
}

