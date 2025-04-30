//
//  NewLocationViewController.swift
//  AVA_Photo_App
//
//  Created by Andrew Lawrence on 4/29/25.
//

import UIKit
import CoreData

class NewLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgPlacePhoto: UIImageView!
    @IBOutlet weak var lblCoordinates: UILabel!
    
    let imagePicker = UIImagePickerController()
    var currentPlace: SavedLocation?
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)

        // Load image if editing an existing place
        if let place = currentPlace, let imageData = place.photo {
            imgPlacePhoto.image = UIImage(data: imageData)
            imgPlacePhoto.contentMode = .scaleAspectFit
            txtTitle.text = place.title
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }



    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }

    @IBAction func choosePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            imgPlacePhoto.image = selectedImage
            imgPlacePhoto.contentMode = .scaleAspectFit
        } else if let originalImage = info[.originalImage] as? UIImage {
            imgPlacePhoto.image = originalImage
            imgPlacePhoto.contentMode = .scaleAspectFit
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveLocation(_ sender: Any) {
        guard let title = txtTitle.text, !title.isEmpty else {
            print("Title is required")
            return
        }

        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            print("Could not get Core Data context")
            return
        }

        let newLocation = SavedLocation(context: context)
        newLocation.title = title
        newLocation.latitude = latitude
        newLocation.longitude = longitude

        if let image = imgPlacePhoto.image {
            newLocation.photo = image.jpegData(compressionQuality: 0.8)
        }

        do {
            try context.save()
            print("Saved successfully")

            // Show coordinates
            lblCoordinates.text = "Lat: \(latitude)\nLong: \(longitude)"
            lblCoordinates.textAlignment = .center
        } catch {
            print("Failed to save location: \(error)")
        }
    }

}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


