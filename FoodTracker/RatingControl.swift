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
    var rating = 0
    
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
        print("Button pressed")
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
        
        // create new buttons
        for _ in 0..<starCount {
            // Create the button:
            let button = UIButton()
            // = convenience initializer
            // creates 0 sized button, positioning is done by the stack (Auto Layout) and position will be defined by adding constraints
            
            button.backgroundColor = UIColor.orange
            
            // button constraints:
            button.translatesAutoresizingMaskIntoConstraints = false    // disables automatically generated constraints
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true   // constraint needs to be activated
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // setup button action:
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            
            // add button to stack:
            addArrangedSubview(button)  // adds view as subview of RatingControl + instructs RatingControl to create constraints needed
            
            // add new button to control button array:
            ratingButtons.append(button)
        }
    }
}
