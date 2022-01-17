//
//  MapEventVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 08/01/2022.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore

class MapEventVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let location = CLLocationManager()
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var selectedLat:CLLocationDegrees?
    var selectedLon:CLLocationDegrees?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
        mapView.delegate = self
        location.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = selectedLat!
            let longitude = selectedLon!
            let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 17.0)
            
            self.mapView.animate(to: camera)
        }
    }
}

