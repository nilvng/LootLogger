//
//  ImageStore.swift
//  LootLogger
//
//  Created by Nil Nguyen on 3/4/21.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(forKey key : String) -> URL {
        // generate URL from given key
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(_ image: UIImage, forKey key: String){
        cache.setObject(image, forKey: key as NSString)
        // create url for the image
        let url = imageURL(forKey: key)
        // turn image to jpeg data
        if let data = image.jpegData(compressionQuality: 0.5){
            try? data.write(to: url)
        }
        
    }
    
    func image(forKey key: String) -> UIImage? {
        // if image has already loaded before, reused it from the cache
        if let cachedImage =  cache.object(forKey: key as NSString) {
            return cachedImage
        }
        // if it is not, load from the list with the give url
        let url = imageURL(forKey: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else { return nil }
        // save it to the cache list
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key : String) {
        // remove image from cache
        cache.removeObject(forKey: key as NSString)
        // remove image from Disk
        let url = imageURL(forKey: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch  {
            print("Error removing image from disk: \(error)")
        }
    }
}
