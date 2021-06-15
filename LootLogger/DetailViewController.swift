//
//  DetailViewController.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/24/21.
//

import UIKit
class DetailViewController: UIViewController,
                            UITextFieldDelegate,
                            UINavigationControllerDelegate,
                            UIImagePickerControllerDelegate{
    // MARK: Properties
    @IBOutlet var nameField: UITextField!
    @IBOutlet var serialNumberField: UITextField!
    @IBOutlet var valueField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView!
    
    var item : Item! {
        didSet{
            navigationItem.title = item.name
        }
    }
    
    var imageStore : ImageStore!
    
    let numberFormatter : NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // Used by our scene delegate to return an instance of this class from our storyboard.
    static func loadFromStoryboard() -> DetailViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
    }

    
    class func detailViewControllerForItem(_ item: Item, imageStore: ImageStore) -> UIViewController {
        print("DetailVC: load from storyboard")
        let detailViewController = loadFromStoryboard()
        detailViewController!.item = item
        detailViewController!.imageStore = imageStore
        return detailViewController!
    }

    
    // MARK: ImagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        // store image in image store (cache)
        imageStore.setImage(image, forKey: item.itemKey)
        // display image in detail view
        imageView.image = image
        // manually dismiss modal
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Camera
    
    func imagePicker(for sourceType : UIImagePickerController.SourceType) -> UIImagePickerController{
        let imageController = UIImagePickerController()
        imageController.sourceType = sourceType
        imageController.delegate = self
        return imageController
    }
    
    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        // given user 2 options to provide image of their properties: from Camera or Library
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {_ in
                print("Present camera")
                let imageController = self.imagePicker(for: .camera)
                self.present(imageController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)

        }
        
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: {_ in
            print("Present photo library")
            let imageController = self.imagePicker(for: .photoLibrary)
            imageController.modalPresentationStyle = .popover
            imageController.popoverPresentationController?.barButtonItem = sender // what is this?
            self.present(imageController, animated: true, completion: nil)

        })
        
        alertController.addAction(photoLibraryAction)
        // the third button for cancelling the function
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // when receive the item object, it will redesign the view
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
        
        imageView.image = imageStore.image(forKey: item.itemKey)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // dismiss the keyboard if any
        view.endEditing(true)
        // update item according to corresponding text field
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        if let valueText = valueField.text,
           let value = numberFormatter.number(from: valueText){
            // only assign if the inputed value is valid value
            item.valueDollars = value.doubleValue
        } else {
            // else return to its default value: 0
            item.valueDollars = 0
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "editDate":
            let dateEditVC = segue.destination as! DateEditViewController
            dateEditVC.item = self.item
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
    //MARK: TextFieldDelegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        // close the keyboard if the background is tapped
        view.endEditing(true)
    }
    
}
