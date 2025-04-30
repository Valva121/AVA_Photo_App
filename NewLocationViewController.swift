//
//  NewLocationViewController.swift
//  AVA_Photo_App
//
//  Created by Andrew Lawrence on 4/29/25.
//

import UIKit
import CoreData
import CoreLocation

class NewLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var imgPlacePhoto: UIImageView!
    @IBOutlet weak var lblCoordinates: UILabel!
    
    let imagePicker = UIImagePickerController()
    var currentPlace: SavedLocation?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var locationManager: CLLocationManager!

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
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status : CLAuthorizationStatus){
        if status == .authorizedWhenInUse{
            print("Permission granted")
        }
        else{
            print("Permission Not granted")
        }
        
    }
    
    
    @IBAction func deviceCoordinates(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingLocation()
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

        // If we're editing an existing place, update the currentPlace
        if let place = currentPlace {
            // Update the existing place
            place.title = title
            place.latitude = locationManager.location?.coordinate.latitude ?? 0.0
            place.longitude = locationManager.location?.coordinate.longitude ?? 0.0

            if let image = imgPlacePhoto.image {
                place.photo = image.jpegData(compressionQuality: 0.8)
            }

            do {
                try context.save()
                print("Updated successfully")

                // Set the coordinate label with updated values
                let coordinateString = String(format: "Lat: %.5f, Lon: %.5f", place.latitude, place.longitude)
                lblCoordinates.text = coordinateString
                lblCoordinates.textAlignment = .center

            } catch {
                print("Failed to update location: \(error)")
            }

        } else {
            // If there's no currentPlace, create a new one
            let newLocation = SavedLocation(context: context)
            newLocation.title = title
            newLocation.latitude = locationManager.location?.coordinate.latitude ?? 0.0
            newLocation.longitude = locationManager.location?.coordinate.longitude ?? 0.0

            if let image = imgPlacePhoto.image {
                newLocation.photo = image.jpegData(compressionQuality: 0.8)
            }

            do {
                try context.save()
                print("Saved successfully")

                // Set the coordinate label with new values
                let coordinateString = String(format: "Lat: %.5f, Lon: %.5f", newLocation.latitude, newLocation.longitude)
                lblCoordinates.text = coordinateString
                lblCoordinates.textAlignment = .center

            } catch {
                print("Failed to save location: \(error)")
            }
        }
    }


    func coordinatesToAddress(lat: Double, lon: Double) -> String{
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: lat, longitude: lon)
        var address = " hello"
        
        geocoder.reverseGeocodeLocation(location){placemarks, error in
            if let error = error {
                print("reverse geocoding failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                let street = placemark.thoroughfare ?? ""
                let city = placemark.locality ??  ""
                let state = placemark.administrativeArea ?? ""
            
                address = "\(street), \(city),\(state)"
            }
            else{
                address = "no address found"
            }
            
        }
        return address
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


