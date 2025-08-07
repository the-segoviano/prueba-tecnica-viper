//
//  FirestoreService.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import Foundation
import FirebaseFirestore
import UIKit

enum FirestoreError: Error {
    case decodingError
    case noProfileFound
}

class FirestoreService {
    
    private let db = Firestore.firestore()
    
    func saveProfile(name: String, imageBase64: String, completion: @escaping (Error?) -> Void) {
        let profileData: [String: Any] = [
            "fullName": name,
            "imageBase64": imageBase64,
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("profiles").addDocument(data: profileData) { error in
            completion(error)
        }
    }
    
    func fetchLastProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        db.collection("profiles").order(by: "createdAt", descending: true).limit(to: 1).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot?.documents.first else {
                completion(.failure(FirestoreError.noProfileFound))
                return
            }
            
            let data = document.data()
            let id = document.documentID
            let name = data["fullName"] as? String ?? "Sin nombre"
            
            if let imageBase64 = data["imageBase64"] as? String,
               let imageData = Data(base64Encoded: imageBase64),
               let image = UIImage(data: imageData) {
                let profile = Profile(id: id, fullName: name, image: image)
                completion(.success(profile))
            } else {
                completion(.failure(FirestoreError.decodingError))
            }
        }
    }
}

