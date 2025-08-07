//
//  Alerts.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import UIKit

class Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.Strings.ok, style: .default, handler: nil))
        DispatchQueue.main.async { vc.present(alert, animated: true) }
    }
    
    static func showIncompleteFormAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Campo vacío",
                       message: "El campo del nombre de usuario requiere de un valor.")
    }
    
    static func showWrongFormatUsernameAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Caracteres no válidos",
                       message: "Solo se aceptan caracteres álfabeticos")
    }
    
    static func showPickupANewImageAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Seleccione una imagen diferente",
                       message: "")
    }
    
    static func showSuccessAlert(on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: "Éxito!",
                       message: "Su imagen fue guardada.")
    }
    
    
    static func show(title: String, message: String, on vc: UIViewController) {
        showBasicAlert(on: vc,
                       with: title,
                       message: message)
    }
    
    
}
