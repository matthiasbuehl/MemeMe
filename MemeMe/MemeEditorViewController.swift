//
//  ViewController.swift
//  MemeMe
//
//  Created by Matthias Buehl on 8/29/20.
//  Copyright © 2020 Matthias Buehl. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!


    let defaultTextTop = "TOP"
    let defaultTextBottom = "BOTTOM"
    let shareBtn = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share(_:)))

    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.strokeWidth: -3,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.backgroundColor: UIColor.clear,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        configure(topTextField, with: defaultTextTop)
        configure(bottomTextField, with: defaultTextBottom)
        configureNavigationBar()
        configureBottomToolbar()
//        tabBarController?.tabBar.isHidden = true
//        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        shareButton.isEnabled = false
//        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func configure(_ textField: UITextField, with defaultText: String) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.borderStyle = .none
        textField.delegate = self
    }

    func configureToolbars(hide: Bool) {
        navigationController?.setToolbarHidden(hide, animated: false)
        navigationController?.navigationBar.isHidden = hide
    }

    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = shareBtn
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
    }

    func configureBottomToolbar() {
        let cameraBtn = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takeNewPhoto))
        let albumBtn = UIBarButtonItem(barButtonSystemItem: .play , target: self, action: #selector(pickImageFromAlbum))
        let spacerBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        toolbarItems = [cameraBtn, spacerBtn, albumBtn]
        navigationController?.setToolbarHidden(false, animated: false)
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func takeNewPhoto(_ sender: Any) {
        pickAnImage(from: .camera)
    }

    @objc func pickImageFromAlbum(_ sender: Any) {
        pickAnImage(from: .photoLibrary)
    }

    @objc func share(_ sender: Any) {
        let meme = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [meme], applicationActivities: [])

        vc.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in

            if activityError != nil {
                print("error: \(activityError)")
            }

            if completed {
                self.save(memedImage: meme)
            }
        }

        present(vc, animated: true)
    }

    @objc func cancel(_ sender: Any) {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    func
        save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        meme.save()
    }

    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        configureToolbars(hide: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)

        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        configureToolbars(hide: false)

        return memedImage
    }

    func pickAnImage(from source: UIImagePickerController.SourceType) {
        let vc = UIImagePickerController()
        vc.delegate = self

        if UIImagePickerController.isSourceTypeAvailable(source) {
            vc.sourceType = .photoLibrary
        }

        present(vc, animated: true) {
            self.shareBtn.isEnabled = true
        }
    }
}

extension MemeEditorViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
    }
}

extension MemeEditorViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if [defaultTextTop, defaultTextBottom].contains(textField.text!) {
            textField.text = ""
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
