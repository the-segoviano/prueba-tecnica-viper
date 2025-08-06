//
//  UITableViewCell+Extension.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

extension UITableViewCell {
    
    func releaseView() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
    }
    
}
