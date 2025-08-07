//
//  UsernameCell.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class UsernameCell: BaseTableViewCell {
    
    lazy var usernameTextField: UITextField = {
        let field = CustomTextField.getTextField(withPlaceholder: Constants.Strings.username)
        field.keyboardType = .alphabet
        field.tag = Constants.Tags.userNameInput
        return field
    }()
    
    func setUpView() {
        selectionStyle = .none
        addSubview(usernameTextField)
        usernameTextField.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
}
