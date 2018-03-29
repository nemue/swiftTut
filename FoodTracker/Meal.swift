//
//  Meal.swift
//  FoodTracker
//
//  Created by Nele Müller on 27.03.18.
//

import UIKit
import os.log

class Meal: NSObject, NSCoding {
    
    // MARK: - Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    // MARK: - Archiving Paths
    
    // uses the file manager’s urls(for:in:) method to look up the URL for your app’s documents directory (where your app can save data for the user)
    // method returns an array of URLs, first parameter returns an optional containing the first URL in the array -> force unwrapped
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    // create the file URL by appending meals to the end of the documents URL:
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")

    
    // MARK: - Types
    
    struct PropertyKey {
        // to save data, values need to be assigned to a key (key = string value) -> keys can be saved in struct
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    // MARK: - Initialization
    
    init?(name: String, photo: UIImage?, rating: Int){
    // failable initializer -> returns an optional (value or nil) -> needs to be unwrapped
        
        // name must not be empty:
        guard !name.isEmpty else { //
            return nil
        }
        
        // rating must be between 0 and 5 inclusively
        guard (rating >= 0 && rating <= 5) else {
            return nil
        }
        
        /* A guard statement declares a condition that must be true in order for the code after the guard statement to be executed.
         If the condition is false, the guard statement’s else branch must exit the current code block.  */
        
        // initialize stored properties:
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    // MARK: - NSCoding
    
    func encode(with aCoder: NSCoder) {
        // prepares the class’s information to be archived
        
        // encode the value of each property on the Meal class and store them with their corresponding key:
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // unarchives the data when the class is created
        // "convenience" means that this is a secondary initializer, and that it must call a designated initializer from the same class -> self.init
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String
            else {
                os_log("Unable to decode the name for the Meal object.", log: OSLog.default, type: .debug)
                return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // must call designated initializer
        self.init(name: name, photo: photo, rating: rating)
    }
}
