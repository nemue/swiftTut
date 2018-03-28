//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Nele on 17.03.18.
//

import UIKit

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    @IBOutlet fileprivate weak var nameTextField: UITextField?
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle the text field’s user input through delegate callbacks.
        // View Controller is delegate.
        nameTextField?.delegate = self
        
        self.setupUIElements()
        self.setupBackground()
    }
    

    // MARK: - UIFIeldTextDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // gets called when user presses enter/taps done
        
        // textField ist nicht mehr first responder -> Hide the keyboard:
        textField.resignFirstResponder()
        
        // indicates, whether the system should process the event -> true
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // is called after the text field resigns its first-responder status
        
        // TODO
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
    
    // MARK: - UINavigationControllerDelegate

    
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
        // text steht "wirklich" im textfeld und wird beim antippen gelöscht
        // placeholder im storyboard wird auch bei eingabe hellgrau angezeigt
        // self.mealNameLabel?.text = "Crash"
        
        
        self.photoImageView.image = UIImage(named: "DefaultPhoto");
    }
    
    func setupBackground() {
        // Bself.view.backgroundColor = UIColor.yellow
    }
}
