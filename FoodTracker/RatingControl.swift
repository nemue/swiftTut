//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Nele Müller on 23.03.18.
//

import UIKit

class RatingControl: UIStackView {
    
    // MARK: - Initialisation
    override init(frame: CGRect) {
        // for programmaticall initialising the view
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        // for initialising the view through storyboard
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    private func setupButtons(){
        // Create the button:
        let button = UIButton()
        button.backgroundColor = UIColor.red
    }
}
