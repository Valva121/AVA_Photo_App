//
//  MapViewController.swift
//  AVA_Photo_App
//
//  Created by user259401 on 4/29/25.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   /*
    - Controls the map and adds the pins (annoations)
    - Fetching the saved locations in the Core Data (SavedLocation)--> in NewLocationViewController so we can display them here

    */
    
    //Connects to the MapView from the storyboard
    @IBOutlet weak var mapView: MKMapView!
    //Segmented control to switch and choose the map type
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    
    //Connects to the location manager to get the user's location
    var locationManager = CLLocationManager()
    //Array that stores the saved pins (places from Core Data).
    var savedLocations: [SavedLocation] = []
    
    
    @IBAction func mapTypeChange(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex{
               case 0:
                   mapView.mapType = .standard
               case 1:
                   mapView.mapType = .hybrid
               case 2:
                   mapView.mapType = .satellite
               default: break
               }
    }
  
             
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapView:", mapView ?? "nil")
        print("Segment:", sgmtMapType ?? "nil")
        //let's set it up
        // Set up location manager
        //Showing the User's Location on the Map by setting up the custom user tracking
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() //ask for permission to use location
        
        //Set the delegate of the map view to be the map view controller
        mapView.delegate = self
        mapView.showsUserLocation = true
        getLocations()
    
        
    }
    
    //Displays the User's Location on the Map
    //It reloads pins if new ones are added in another view
    override func viewWillAppear(_ animated: Bool) {
        getLocations()
    }
    
    //Loads all saved SavedLocation entries from Core Data. Which contains the title, latitude, longitude, and image.
    func getLocations(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let request: NSFetchRequest<SavedLocation> = SavedLocation.fetchRequest()
        do {
            savedLocations = try context.fetch(request)
            
            if savedLocations.isEmpty {
                print("No saved locations found.")
            } else {
                print("Fetched \(savedLocations.count) location(s).")
                addPinAnnotations()
            }
        } catch {
            print("Error fetching locations: \(error)")
        }
    }
    
    //Adds pins (map annotations) for each place on the map while also removing the old pins from the map...
    func addPinAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        
        for location in savedLocations {
            let annotation = MapPoint(
                title: location.title,
                latitude: location.latitude,
                longitude: location.longitude,
                imageData: location.photo
            )
            mapView.addAnnotation(annotation)
        }
        
    }
    
    //Displays the User's location spot of where they took the photo
    
    
}
