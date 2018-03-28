//
//  Meal.swift
//  FoodTracker
//
//  Created by Nele Müller on 27.03.18.
//

import UIKit

class Meal {
    
    // MARK: - Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
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
}
