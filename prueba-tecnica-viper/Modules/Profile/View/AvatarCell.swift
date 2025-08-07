//
//  AvatarCell.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class AvatarCell: BaseTableViewCell {
    
    let localStorage = UserDefaults.standard
    
    let sizeAvatarImageView: CGFloat = 80.0
    
    let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.contentMode = .scaleAspectFit
        avatar.image = UIImage(named: Constants.ImageName.avatar)
        avatar.layer.cornerRadius = 70/2
        avatar.clipsToBounds = true
        return avatar
    }()
    
    
    let containerAvatar: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.clipsToBounds = true
        container.layer.cornerRadius = 80/2
        container.layer.masksToBounds = false
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.5
        container.layer.shadowOffset = CGSize(width: -1, height: 1)
        container.layer.shadowRadius = 5
        return container
    }()
    
    func setUpView() {
        selectionStyle = .none
        addSubview(containerAvatar)
        containerAvatar.isUserInteractionEnabled = true
        containerAvatar.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerAvatar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerAvatar.widthAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.heightAnchor.constraint(equalToConstant: sizeAvatarImageView).isActive = true
        containerAvatar.addSubview(avatar)
        containerAvatar.addBorder(borderColor: .lightGray, widthBorder: 1)
        avatar.isUserInteractionEnabled = true
        avatar.centerXAnchor.constraint(equalTo: containerAvatar.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: containerAvatar.centerYAnchor).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        guard let urlString = UserDefaults.standard.string(forKey: "url-firestore"), !urlString.isEmpty, let url = URL(string: urlString) else {
            self.avatar.image = nil
            guard let avatarData = UserDefaults.standard.data(forKey: "avatar") else {
                return
            }
            
            let dataToView: UIImage = UIImage(data: avatarData)!
            self.avatar.image = dataToView
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                return
            }
            guard
                let httpURLResponse = response as? HTTPURLResponse, (200...299).contains(httpURLResponse.statusCode),
                let data = data, error == nil
            else { return }
            
            DispatchQueue.main.async {
                self.avatar.image = UIImage(data: data)
            }
            
        }
        task.resume()
        
        
    }
    
}
