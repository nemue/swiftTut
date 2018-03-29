//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Nele on 17.03.18.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet fileprivate weak var nameTextField: UITextField?
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    /* This value is either passed by 'MealTableViewController' in 'prepare(for:sender:)'
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        // View Controller is delegate.
        nameTextField?.delegate = self
        
        // display meal data, if editing existing meal:
        if let meal = meal { // if meal is not nil
            navigationItem.title = meal.name
            nameTextField?.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // enable save button only, if a name has been entered -> here: button gets disabled, when view first loads
        updateSaveButtonState()
        
        // self.setupUIElements()   // programmatically set up UI elements (Panos)
    }
    

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // gets called when user presses enter/taps done
        
        // textField ist nicht mehr first responder -> Hide the keyboard:
        textField.resignFirstResponder()
        
        // indicates, whether the system should process the event -> true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // is called after the text field resigns its first-responder status
        
        updateSaveButtonState()
        navigationItem.title = textField.text // sets the title of the scene to entered text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // disable save button while typing:
        saveButton.isEnabled = false
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // dismiss picker if user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            // as? – optional binding for save unwrapping
            // info[UIImagePickerControllerOriginalImage] -> data comes back as Swift Dictionary named “info” (MediaType, OriginalImage...)
            }
        
        // set imageView to image from library
        photoImageView.image = selectedImage
        
        // dismiss the picker:
        dismiss(animated: true, completion: nil)


    }
    
    // MARK: - Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // dismisses the modal scene:
        // (completion: the block to execute after the view controller is dismissed)
        
        // depending on presentation style (modal or push), the view needs to be dismissed in 2 different ways:
        // bool-wert: da meal detail scene in eigenen view controller eingebettet ist, nur true, wenn (+) getippt wird
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        // adding a meal: meal detail scene is presented inside a modal navigation controller
        // editing a meal: meal detail scene is pushed onto a navigation stack
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            // If the view controller has been pushed onto a navigation stack, this property contains a reference to the stack’s navigation controller.
            
            // dismisses the meal detail scene and returns to meal list
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // view controller can be configured before presented with this method:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure destination view controller only when the save button is pressed:_
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            // === identity operator
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField?.text ?? ""
        // ?? returns value of the optional or default value (""), if optional is nil
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // create meal to be passed to MealTableViewController after the unwind segue
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    // MARK: - Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // sender: object that was responsible for triggering the action

        // Hide the keyboard:
        nameTextField?.resignFirstResponder()
        // falls user bild antippt, wärend textfeld aktiv
        
        let imagePickerController = UIImagePickerController()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        
        imagePickerController.sourceType = .photoLibrary
        // only allow photos from library no camera
        // type of imagePickerController.sourceType is UIImagePickerControllerSourceType -> Enum
        
        imagePickerController.delegate = self
        // ViewController is notified when the user picks an image.
        
        present(imagePickerController, animated: true, completion: nil)
        // is executed on implicit self object
        /* func present(_ viewControllerToPresent: UIViewController,
                animated flag: Bool,
                completion: (() -> Void)? = nil)
         
        completion: The block to execute after the presentation finishes.
        This block has no return value and takes no parameters.
        You may specify nil for this parameter.
         
        = completion handler – A closure that’s passed as a parameter to a method
        that calls the closure when it finishes executing. */
    }
    
}

// MARK: - Setup UI Elements

fileprivate extension MealViewController {

    func setupUIElements() {
        
        // self.nameTextField?.text = "Name your meal"
        /* text steht "wirklich" im textfeld und wird beim antippen gelöscht
         placeholder im storyboard wird auch bei eingabe hellgrau angezeigt
         self.mealNameLabel?.text = "Crash" */
        
        // self.photoImageView.image = UIImage(named: "DefaultPhoto");
        // ist auch über storyboard gelöst
    }
    
    // MARK: - Private Methods
    
    private func updateSaveButtonState(){
        // disaöbe save button, if name text field is empty:
        let text = nameTextField?.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
