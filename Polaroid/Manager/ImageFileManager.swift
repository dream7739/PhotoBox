//
//  ImageFileManager.swift
//  Polaroid
//
//  Created by 홍정민 on 7/27/24.
//

import UIKit

struct ImageFileManager {
    private init(){ }
    
    static func createImageDirectory() {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let directoryURL = documentDirectory.appendingPathComponent("images")
        
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: false)
            print("Create Folder Success")
        } catch let error {
            print("Create Folder Error: \(error.localizedDescription)")
        }
    }
    
    static func deleteImageDirectory(){
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let directoryURL = documentDirectory.appendingPathComponent("images")
        
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            do {
                try FileManager.default.removeItem(atPath: directoryURL.path)
            } catch {
                print("File Remove Error", error)
            }
            
        } else {
            print("File No Exist")
        }
    }
    
    static func saveImageToDocument(image: UIImage, filename: String) {

        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("images/\(filename).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("File Save Error", error)
        }
    }
    
    static func loadImageToDocument(filename: String) -> UIImage? {
        
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return nil }
        
        let fileURL = documentDirectory.appendingPathComponent("images/\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return nil
        }
    }
    
    static func removeImageFromDocument(filename: String) {
        guard let documentDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("images/\(filename).jpg")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print("File Remove Error", error)
            }
            
        } else {
            print("File No Exist")
        }
    }
}
