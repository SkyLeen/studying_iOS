//
//  GetCashedImageOperation.swift
//  myVKApp
//
//  Created by Natalya on 03/04/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import UIKit

enum Folders: String {
    case UserAvatars
    case Photos
    case Groups
    case News
    case Dialogs
    case Others
    case Requests
}

class GetCashedImage: Operation {
    
    private let cashLifeTime: TimeInterval = 3600
    private let url: String
    private let userId: String
    private let folder: Folders
    var outputImage: UIImage?
    
    private lazy var filePath: String? = {
        guard let cashDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        let path = getPathName()
        let fileName = String(describing: url.hashValue)
        let filePath = cashDir.appendingPathComponent("\(path)/\(fileName)").path
        
        return filePath
    }()
    
    init(url: String, folderName: Folders, userId: String = "") {
        self.url = url
        self.folder = folderName
        self.userId = userId
    }
    
    override func main() {
        guard filePath != nil && !isCancelled else { return }
        if getImageFromCash()  { return }
        
        guard !isCancelled else { return }
        if !downloadImage() { return }
        
        saveImageToCash()
    }
    
    private func getPathName() -> String {
        let path = userId != "" ? "\(folder.rawValue)/\(userId)" : folder.rawValue
        
        guard let cashDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            else { return path }
        let url = cashDir.appendingPathComponent(path, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return path
    }
    
    private func getImageFromCash() -> Bool {
        guard let fileName = filePath,
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return false}
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cashLifeTime, let image = UIImage(contentsOfFile: fileName) else { return false }
        self.outputImage = image
        
        return true
    }
    
    private func downloadImage() -> Bool {
        guard let url = URL(string: url),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return false }
        
        self.outputImage = image
        
        return true
    }
    
    private func saveImageToCash() {
        guard let path = filePath,  let image = outputImage else { return }
        let data = UIImagePNGRepresentation(image)
        FileManager.default.createFile(atPath: path, contents: data, attributes: nil)
    }
}
