//
//  Constants.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

struct Constants {
    
    struct Strings {
        static let ok = "ok"
        static let cancel = "Cancelar"
        static let send = "Enviar"
        static let username = "nombre del usuario"
        static let close = "Cerrar"
    }
    
    
    struct Value {
        static let htTextField: CGFloat = 48.0
        static let htButton: CGFloat = 40.0
        static let leadingMar: CGFloat = 16.0  // Or Left Margin
        static let trailingMar: CGFloat = -16.0 // Or Right Margin
        static let padding: CGFloat = 8.0
        static let cornerRadius: CGFloat = 15.0
        static let sizeProductImage: CGFloat = 30.0
        static let sizeIconHeart: CGFloat = 24.0
    }
    
    
    
    struct Tags {
        static let userNameInput = 1357911
    }
    
    struct ImageName {
        static let avatar: String = "avatar"
    }
    
    struct IdForCell {
        static let genericCell: String = "GenericCell"
        static let usernameCell: String = "UsernameCell"
        static let avatarCell: String = "AvatarCell"
        static let graphCell: String = "GraphCell"
        static let chartTableViewCell: String = "ChartTableViewCell"
        
    }
    
}
