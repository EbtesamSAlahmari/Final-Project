//
//  MapVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 06/01/2022.
//

import UIKit
import GoogleMaps
import Firebase
import FirebaseFirestore

class MapVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var myAddress: UILabel!
    
    let location = CLLocationManager()
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var locationLat:CLLocationDegrees?
    var locationLon:CLLocationDegrees?
    var selectedLatitude:CLLocationDegrees?
    var selectedLongitude:CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.requestWhenInUseAuthorization()
        location.startUpdatingLocation()
       
        mapView.delegate = self
        location.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        let camera = GMSCameraPosition(latitude: self.selectedLatitude!, longitude: self.selectedLongitude!, zoom: 17.0)
        self.mapView.animate(to: camera)
        
    }
    
    @IBAction func addLocationPressed(_ sender: Any) {
        updateSchoolData()
        navigationController?.popViewController(animated: true)
    }
    
    func updateSchoolData() {
        if let userId = userId {
            let loca: [String: Any] = [
                "Latitude": self.locationLat ?? "",
                "Longitude": self.locationLon ?? ""
            ]
            db.collection("Users").document(userId).updateData([
                "schoolLocation" : self.myAddress.text ?? "لم يحدد",
                "loca" : loca
            ])
            {(error) in
                if error == nil {
                    print("update location  Succ..")
                }else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
}

//MARK: -CLLocationManagerDelegate, GMSMapViewDelegate
extension MapVC: CLLocationManagerDelegate, GMSMapViewDelegate  {
    //add pin image to my location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let camera = GMSCameraPosition(latitude: latitude, longitude: longitude, zoom: 17.0)
            
            self.mapView.animate(to: camera)
        }
    }
    
    //add location text to lable
    func myLocation(coordinates: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(coordinates) { response, error in
            if let address = response?.firstResult(),
               let lines = address.lines{
                self.myAddress.text = lines.joined(separator: "\n")
            }
        }
    }

    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        myLocation(coordinates: location)
        self.locationLat = mapView.camera.target.latitude
        self.locationLon = mapView.camera.target.longitude
    }
    //add pin to map
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker()
        let markerLatitude = coordinate.latitude
        let markerLongitude = coordinate.longitude
        marker.position = coordinate
        marker.title = "الاحداثيات"
        marker.snippet = "\(markerLatitude)\n\(markerLongitude)"
        marker.map = mapView
    }
    
    //return marker to my location
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        return false
    }

}
