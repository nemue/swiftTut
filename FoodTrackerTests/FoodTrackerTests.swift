//
//  FoodTrackerTests.swift
//  FoodTrackerTests
//
//  Created by Nele on 17.03.18.
//

import XCTest
@testable import FoodTracker
// gives your tests access to the internal elements of app’s code, except for code marked as private or fileprivate

class FoodTrackerTests: XCTestCase {
    
    // MARK: - Meal Class TEsts
    
    // confirm Meal initializer returns Meal object when passed valid parameters
    func testMealInitializationSucceeds() {
        
        // zero rating:
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // highest positive rating:
        let positiveRatingMeal = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // confirm Meal initializer returns nil when passed wrong parameters
    func testMealInitFails() {
        
        // negative rating:
        let negativeRatingMeal = Meal.init(name: "Negative", photo: nil, rating: -3)
        XCTAssertNil(negativeRatingMeal)
        
        // rating exceeds maximum:
        let largeRatingMeal = Meal.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // empty string:
        let emptyStringMeal = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
