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

class MapViewController:UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
   /*
    - Controls the map and adds the pins (annoations)
    */
    
    //Connects to the MapView from the storyboard
    @IBOutlet weak var mapView: MKMapView!
    
    //This array holds all the places loaded from the Core Data --> where all the user's saved places will be displayed
    var places: [Place] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let's set it up
        //Set the delegate of the map view to be the map view controller
        mapView.delegate = self
        
        
        
    }
    
}
