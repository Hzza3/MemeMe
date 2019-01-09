//
//  ViewController.swift
//  MemeMe
//
//  Created by Epic Systems on 12/30/18.
//  Copyright © 2018 AhmedHazzaa. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var buttomToolBar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let textFieldDelegate = TextFieldDelegate()
    var selecedoriginalPhoto = UIImage()
    

    var memedImage = UIImage()
    
//    let memeTextAttributes: [String:Any] = [
//        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
//        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
//        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
//        NSAttributedStringKey.strokeWidth.rawValue: 4.0
//    ]
    
    let memeTextAttributes: [NSAttributedStringKey : Any] = [
        NSAttributedStringKey.strokeColor : UIColor.black,
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth : 4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        topTextField.delegate = textFieldDelegate
        buttomTextField.delegate = textFieldDelegate
        
        setupTextFields()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    func setupTextFields() {
        
        topTextField.text = "TOP"
        buttomTextField.text = "BOTTOM"
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        topTextField.borderStyle = .none
        buttomTextField.defaultTextAttributes = memeTextAttributes
        buttomTextField.textAlignment = .center
        buttomTextField.borderStyle = .none
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if buttomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if buttomTextField.isFirstResponder {
       view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    @IBAction func cameraButtonTapped(_ sender: Any) {
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .camera
        present(imagePickerVC, animated: true, completion: nil)
        
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = .photoLibrary
        present(imagePickerVC, animated: true, completion: nil)
        
    }
  
    func save() {
        if !(topTextField.text?.isEmpty)! && !(buttomTextField.text?.isEmpty)! && memeImageView.image != nil {
           let meme = Meme(topText: topTextField.text!, buttomText: buttomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
        }
    }
    
    func generateMeme() -> UIImage {
        
        navigationBar.isHidden = true
        buttomToolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        buttomToolBar.isHidden = false
        
        return meme
    }
    
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        memedImage = generateMeme()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities:nil)
        activityVC.completionWithItemsHandler = {(type, success, itemsReturned, error) in
            if success {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        selecedoriginalPhoto = UIImage()
        memeImageView.image = selecedoriginalPhoto
        topTextField.text = "TOP"
        buttomTextField.text = "BOTTOM"
        
    }
    
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.contentMode = .scaleAspectFit
            selecedoriginalPhoto = pickedImage
            memeImageView.image = selecedoriginalPhoto
            shareButton.isEnabled = true
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MemeEditorViewController: UITextFieldDelegate {
    
}
