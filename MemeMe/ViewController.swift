//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthias Buehl on 8/29/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var toolbarBottom: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -3,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.backgroundColor: UIColor.clear,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.backgroundColor = .clear
        topTextField.borderStyle = .none
        topTextField.delegate = self

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
        bottomTextField.backgroundColor = .clear
        bottomTextField.borderStyle = .none
        bottomTextField.delegate = self
    }

    // MARK: lifecycle
    override func viewWillAppear(_ animated: Bool) {
        shareButton.isEnabled = false
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }

    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        toolbarTop.isHidden = true
        toolbarBottom.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        toolbarTop.isHidden = false
        toolbarBottom.isHidden = false

        return memedImage
    }

    // MARK: IBActions
    @IBAction func takeNewPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            vc.sourceType = .camera
        }

        present(vc, animated: true) {
            self.shareButton.isEnabled = true
        }
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            vc.sourceType = .photoLibrary
        }

        present(vc, animated: true) {
            self.shareButton.isEnabled = true
        }
    }

    @IBAction func share(_ sender: Any) {
        let meme = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [meme], applicationActivities: [])

        vc.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
            
            if activityError != nil {
                print("error: \(activityError)")
            }

            self.save(memedImage: meme)
        }

        present(vc, animated: true)
    }

    @IBAction func cancel(_ sender: Any) {
    }
}

extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
