//
//  ColorManager.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit
import FirebaseDatabase


class ColorManager {
    private let ref = Database.database().reference()
    private var accentColorHandle: DatabaseHandle?
    
    // Closure para notificar cambios
    var accentColorDidChange: ((UIColor, String) -> Void)?
    
    func startListeningForAccentColor() {
        // Remover observador previo si existe
        stopListening()
        
        // Escuchar cambios en el nodo 'accent'
        accentColorHandle = ref.child("colors/specific_colors/background").observe(.value) { [weak self] snapshot, _ in
            guard let self = self,
                  let value = snapshot.value as? [String: Any],
                  let hex = value["hex"] as? String,
                  let name = value["name"] as? String,
                  let color = UIColor(hex: hex) else {
                return
            }
            
            self.accentColorDidChange?(color, name)
        }
    }
    
    func stopListening() {
        if let handle = accentColorHandle {
            ref.removeObserver(withHandle: handle)
            accentColorHandle = nil
        }
    }
    
    deinit {
        stopListening()
    }
}
