//
//  MemeViewController.swift
//  MemeMeV1
//
//  Created by Petrik on 17/09/15.
//  Copyright © 2015 Peter Krajcir. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // disable top button for sharing until user selects an image
        disableTopButtons()
        
        // initialise top and bottom text field with the default values
        initialiseTextField(topTextField)
        initialiseTextField(bottomTextField)
    }
    
    func initialiseTextField(textField:UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion:nil)
        enableTopButtons()
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion:nil)
        enableTopButtons()
    }
    
    func enableTopButtons() {
        shareButton.enabled = true
    }
    
    func disableTopButtons() {
        shareButton.enabled = false
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelView(sender: AnyObject) {
        // dismiss the Meme Editor View when user presses cancel button
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareImage(sender: AnyObject) {
        let generatedMemedImage = generateMemedImage()
        saveMeme(generatedMemedImage)
        let activityController = UIActivityViewController(activityItems: [generatedMemedImage], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
        activityController.completionWithItemsHandler = {(activityType:String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) in
            // when user finished work in activity view, dismiss the Meme Editor View
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveMeme(generatedMemeImage:UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image!, memedImage: generatedMemeImage)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // render view to an image
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == topTextField && textField.text != "TOP") ||
           (textField == bottomTextField && textField.text != "BOTTOM"){
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}

