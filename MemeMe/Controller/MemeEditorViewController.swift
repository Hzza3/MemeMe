//
//  MemeEditorViewController.swift
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
    
    let memeTextAttributes: [String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        
        setupTextField(topTextField, text: "TOP")
        setupTextField(buttomTextField, text: "BOTTOM")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func updateBarsStatus() {
        navigationBar.isHidden = !navigationBar.isHidden
        buttomToolBar.isHidden = !buttomToolBar.isHidden
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        presentImagePicker(source: .camera)
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
        presentImagePicker(source: .photoLibrary)
    }
    
    func save() {
        if let topText = topTextField.text, let bottomText = buttomTextField.text, let image = memeImageView.image {
            let meme = Meme(topText: topText, buttomText: bottomText, originalImage: image, memedImage: memedImage)
            SavedMemes.shared.memes.append(meme)
        }
    }
    
    func generateMeme() -> UIImage {
        
        updateBarsStatus()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        updateBarsStatus()
        
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
        
        dismiss(animated: true, completion: nil)
        
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
    
    func presentImagePicker(source: UIImagePickerController.SourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = source
        present(imagePickerVC, animated: true, completion: nil)
    }
    
}

extension MemeEditorViewController: UITextFieldDelegate {
    
    func setupTextField(_ textField: UITextField, text: String) {
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.borderStyle = .none
        textField.text = text
        textField.delegate = textFieldDelegate
    }
}
