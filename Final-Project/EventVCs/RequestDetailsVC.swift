//
//  RequestDetailsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 05/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMaps

class RequestDetailsVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var schoolDescription: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var startDateTxt: UILabel!
    @IBOutlet weak var endDateTxt: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var acceptRequestBtn: UIButton!
    @IBOutlet weak var refuseRequestBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var contentView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var selectedRequest:RequestEvent?
    var requestStatus = ""
    var vcNum = 0
    let location = CLLocationManager()
    var locationLat:CLLocationDegrees?
    var locationLon:CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        mapView.delegate = self
        location.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRequest()
        nameTxt.text = selectedRequest?.schoolName
        startDateTxt.text = selectedRequest?.startDate
        endDateTxt.text = selectedRequest?.endDate
        priceLbl.text = "\((selectedRequest?.totalPrice)!)"
        
        if vcNum == 2 {
            acceptRequestBtn.isHidden = true
            refuseRequestBtn.isHidden = true
        }
        
        contentView.applyShadow(cornerRadius: 20)
        mapView.applyShadow(cornerRadius: 20)
        
        
    }
    
    @IBAction func acceptRequestPressed(_ sender: Any) {
        updateRequestStatus(status: "مقبولة")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func refuseRequestPressed(_ sender: Any) {
        updateRequestStatus(status: "مرفوضة")
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func showSchoolLocation(_ sender: UITapGestureRecognizer) {
       if sender.state == .ended {
            sender.numberOfTapsRequired = 1
            performSegue(withIdentifier: "showLocation", sender: nil)
            print("-----------==============")
       }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLocation" {
            let nextVc = segue.destination as! MapEventVC
            nextVc.selectedLat = self.locationLat
            nextVc.selectedLon = self.locationLon
        }
    }
   
 
//MARK:  -get specific documents from a collection
    func loadRequest() {
        db.collection("Users").whereField("schoolID", isEqualTo: (selectedRequest?.schoolID)!).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.schoolDescription.text = data["schoolDescription"] as? String ?? "لايوجد"
                    self.phone.text = data["schoolPhone"] as? String ?? "لايوجد"
                    self.email.text = data["schoolEmail"] as? String ?? "لايوجد"
                    //self.locationLbl.text = data["schoolLocation"] as? String ?? "لم يحدد"
                    let loca = data["loca"] as? [String: Any]
                    self.locationLat = loca?["Latitude"] as? Double ?? 0.0
                    self.locationLon = loca?["Longitude"] as? Double ?? 0.0
                    
                    let marker = GMSMarker()
                    let camera = GMSCameraPosition(latitude: self.locationLat!, longitude: self.locationLon!, zoom: 17.0)
                    let coordinate = CLLocationCoordinate2D(latitude: self.locationLat! , longitude: self.locationLon!)
                    marker.position = coordinate
                    marker.map = self.mapView
                    self.mapView.animate(to: camera)
                    
                }
                
            }
        }
    }
    
    func updateRequestStatus(status: String) {
        if let userId = userId {
            db.collection("Requests").whereField("requestID", isEqualTo: (selectedRequest?.requestID)!).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        if document == document {
                            self.db.collection("Requests").document(document.documentID).updateData(["requestStatus" : status]) { error in
                                    if error == nil {
                                        print("update requestStatus  Succ..")
                                    }else {
                                        print(error!.localizedDescription)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}

