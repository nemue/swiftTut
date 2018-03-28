//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Nele Müller on 23.03.18.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // @IBDesignable gives Interface Builder access to objects and constraints
    // -> no "missing constraints" warnings and correct display of elements in storyboard
    
    // MARK: - Properties
    private var ratingButtons = [UIButton]()    // list of buttonstele
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            // property observer -> called every time, a property is set
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    // @IBInspectable: Anpassungen über Attribut Inspector möglich
    // Angabe von default-Werte in Klammern -> Anpassung über Attribute Inspector möglich
    
    // MARK: - Initialisation
    override init(frame: CGRect) {
        // for programmaticall initialising the view
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        // for initialising the view through storyboard
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: - Button Action
    @objc func ratingButtonTapped(button: UIButton){
    /* @objc is needed, because method is later called
         alternatively: use @objcMembers on the class
         when using @IBAction @objc is automatically implied
        */
        guard let index = ratingButtons.index(of: button) else {
            // indexOf(_:) method attempts to find the selected button in the array of buttons and to return the index at which it was found
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // calculate rating of the selected button:
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // if the selected star represents the current rating, reset the rating to 0:
            rating = 0
        } else {
            rating = selectedRating
        }
    }
    
    // MARK: - Private Methods
    private func setupButtons(){
        
        // clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            /* button is no longer managed by stackviw (sizes and position are no longer calculated)
             -> button still exists as subview of stackview
             */
            button.removeFromSuperview()    // removes button view from stack view
        }
        ratingButtons.removeAll()
        
        // load button images
        // to work with Interface Builder, bundle has to be explicitly specified
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)

        // create new buttons
        for index in 0..<starCount {
            // Create the button:
            let button = UIButton()
            // = convenience initializer
            // creates 0 sized button, positioning is done by the stack (Auto Layout) and position will be defined by adding constraints
            
            // set button images:
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // add constraints:
            button.translatesAutoresizingMaskIntoConstraints = false    // disables automatically generated constraints
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true   // constraint needs to be activated
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set accessibility label
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // setup button action:
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to stack:
            addArrangedSubview(button)  // adds view as subview of RatingControl + instructs RatingControl to create constraints needed
            
            // add new button to control button array:
            ratingButtons.append(button)
        }
        
        updateButtonSelectionState()
    }
    
    // helper method to select all stars with smaller index than the one selected:
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            // if if index of button is less than the rating, button should be selected
            button.isSelected = index < rating  // index < rating will be true for all stars including the one tapped
            
            // set the hint string -> only for currently selected star:
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // calculate the value string:
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set"
            }
            
            // assign hint string and value string:
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
