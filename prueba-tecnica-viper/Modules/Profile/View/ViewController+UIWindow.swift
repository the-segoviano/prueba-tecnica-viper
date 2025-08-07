//
//  ViewController+UIWindow.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

extension UIWindow {
    func updateBackgroundColor(_ color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = color
            self.rootViewController?.view.backgroundColor = color
        }
    }
}
