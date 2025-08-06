//
//  BaseButton.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class BaseButton {
    
    class func standardButton(withTitle title: String) -> UIButton {
        let button = BaseButton.getButton(withTitle: title, withColor: .systemBlue)
        return button
    }
    
    static func getButton(withTitle title: String, withColor color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Value.cornerRadius
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitle(title, for: .normal)
        button.backgroundColor = color
        return button
    }
    
}
