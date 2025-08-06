//
//  ViewController+UIImagePickerController.swift
//  prueba-tecnica-viper
//
//  Created by Luis Segoviano on 06/08/25.
//

import UIKit
import Photos

//
// MARK: - UIImagePickerController
//

enum MediaSource: String {
    case camera
    case gallery
}


extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @objc func handleEventCamera() {
        selectImage()
    }
    
    func selectImage() {
        let selectPhotoAlert = UIAlertController(title: "Update Avatar",
                                                 message: "",
                                                 preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                self.requestPermissionsForCamera(origen: .camera)
            }
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action: UIAlertAction) in
            DispatchQueue.main.async {
                self.requestPermissionsForCamera(origen: .gallery)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        selectPhotoAlert.addAction(cameraAction)
        selectPhotoAlert.addAction(galleryAction)
        selectPhotoAlert.addAction(cancelAction)
        self.present(selectPhotoAlert, animated: true, completion: nil)
    }
    
    
    func requestPermissionsForCamera(origen: MediaSource) {
        if origen == .camera {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { status in
                if status {
                    self.openCamera()
                }
                else{
                    self.openSettings()
                }
            }
        }
        if origen == .gallery {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized {
                        self.openGallery()
                }
                else{
                    self.openSettings()
                }
            })
        }
    }
    
    
    func openSettings() {
        let alertController = UIAlertController (title: "Requires Permission",
                                                 message: "This app requires permissions for use your Camera/Gallery.",
                                                 preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
            else{
                let alertVC = UIAlertController(title: "Este dispositivo no cuenta con camara",
                                                message: "", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
            }
        }
    }
    
    func openGallery() {
        DispatchQueue.main.async {
           if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
           }
        }
    }
    
    
    
    // MARK: Delegates UIPicker
    
    /**
         Swift Dictionary named “info”.
         We have to unpack it from there with a key asking for what media information we want.
         We just want the image, so that is what we ask for.
         
         For reference, the available options are:

         UIImagePickerControllerMediaType
         UIImagePickerControllerOriginalImage
         UIImagePickerControllerEditedImage
         UIImagePickerControllerCropRect
         UIImagePickerControllerMediaURL
         UIImagePickerControllerReferenceURL
         UIImagePickerControllerMediaMetadata
     
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let tempPathImagePicked = info[UIImagePickerController.InfoKey.imageURL] as? URL { // Galeria
            let imageName = tempPathImagePicked.lastPathComponent
            let nameImageFiltered = imageName.filterString(charsToRemove: ["-", " ", "_"])
            let imageExtension = nameImageFiltered.fileExtension()
            let _ = (imageName.isEmpty) ? "avatar.png" : imageName // fileName
            
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                var imageDataRepresentation: Data
                if imageExtension == "jpeg" || imageExtension == "jpg" {
                    let imageResized = pickedImage.scaled(to: CGSize(width: 1024, height: 1024),
                                                          scalingMode: UIImage.ScalingMode.aspectFill)
                    let imageCompressed = imageResized.compressImage(image: imageResized)
                    imageDataRepresentation = imageCompressed.jpegData(compressionQuality: 1.0)!
                }
                else{
                    imageDataRepresentation = pickedImage.pngData()!
                }
                
                storeImageAndReloadView(imageSelected: imageDataRepresentation)
                
            }
        }
        else{ // Desde camara.
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let imageResized = pickedImage.scaled(to: CGSize(width: 1024, height: 1024),
                                                      scalingMode: UIImage.ScalingMode.aspectFill)
                let imageCompressed = imageResized.compressImage(image: imageResized)
                let imageDataRepresentation = imageCompressed.jpegData(compressionQuality: 1.0)!
                
                storeImageAndReloadView(imageSelected: imageDataRepresentation)
                
            }
            
        }
        
    } // imagePickerController
    
    //
    // MARK: Store in UserDefault the image selected
    //
    func storeImageAndReloadView(imageSelected: Data) {
        UserDefaults.standard.set(true, forKey: "was-avatar-updated")
        UserDefaults.standard.set("", forKey: "url-firestore")
        UserDefaults.standard.set(imageSelected, forKey: "avatar")
        let avatarCellIndexPath = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [avatarCellIndexPath], with: .automatic)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
}
