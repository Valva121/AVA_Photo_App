//
//  MapPoint.swift
//  AVA_Photo_App
//
//  Created by user259401 on 4/29/25.
//

import Foundation
import MapKit

// Will be used to store the annotation for a single point on the map.
class MapPoint: NSObject, MKAnnotation{
    var title: String?
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
