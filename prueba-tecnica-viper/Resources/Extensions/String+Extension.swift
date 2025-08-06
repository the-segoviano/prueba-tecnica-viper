//
//  String+Extension.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation

extension String {
    
    //
    // MARK: Filtrar Imagen en el upload de una imagen
    //
    func filterString(charsToRemove: [Character]) -> String {
        return String(self.filter { !charsToRemove.contains($0) } )
    }
    
    func fileExtension() -> String {
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        }
        else {
            return ""
        }
    }
    
    func isValidInput() -> Bool {
        let myCharSet = CharacterSet(charactersIn:"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        let output: String = self.trimmingCharacters(in: myCharSet.inverted)
        let isValid: Bool = (self == output)
        print("\(isValid)")
        return isValid
    }
    
}
