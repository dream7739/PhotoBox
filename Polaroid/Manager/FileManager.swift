//
//  FileManager.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import UIKit

extension BaseViewController {
    func configureImageFile(_ isClicked: Bool, _ data: PhotoResult){
        let imageID = data.id
        let imageURL = data.urls.small
        let profileURL = data.user.profile_image.medium
        
        if isClicked {
            imageURL.loadImage { [weak self] result in
                switch result {
                case .success(let value):
                    self?.saveImageToDocument(image: value, filename: imageID)
                case .failure(let error):
                    self?.showToast(error.localizedDescription)
                }
            }
            
            profileURL.loadImage { [weak self] result in
                switch result {
                case .success(let value):
                    self?.saveImageToDocument(image: value, filename: imageID + "_profile")
                case .failure(let error):
                    self?.showToast(error.localizedDescription)
                }
            }
            
        }else{
            self.removeImageFromDocument(filename: imageID)
            self.removeImageFromDocument(filename: imageID + "_profile")
        }
    }
    
    func saveImageToDocument(image: UIImage, filename: String) {
          
          guard let documentDirectory = FileManager.default.urls(
              for: .documentDirectory,
              in: .userDomainMask).first else { return }
          
          let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
          
          guard let data = image.jpegData(compressionQuality: 0.5) else { return }
          
          do {
              try data.write(to: fileURL)
          } catch {
              print("file save error", error)
          }
      }
    
    func loadImageToDocument(filename: String) -> UIImage? {
         
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
         
        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                return UIImage(contentsOfFile: fileURL.path())
            } else {
                return nil
            }
        } else {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                return UIImage(contentsOfFile: fileURL.path)
            } else {
                return nil
            }
        }
        
    }
    
    func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }

        let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
        
        if #available(iOS 16.0, *) {
            if FileManager.default.fileExists(atPath: fileURL.path()) {
                
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path())
                } catch {
                    print("file remove error", error)
                }
                
            } else {
                print("file no exist")
            }
        } else {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(atPath: fileURL.path)
                } catch {
                    print("file remove error", error)
                }
                
            } else {
                print("file no exist")
            }
        }
        
    }
}
