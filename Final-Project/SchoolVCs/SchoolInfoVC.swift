//
//  SchoolInfoVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleMaps

class SchoolInfoVC: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var schoolDescription: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!

    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var editStatus = true
    let location = CLLocationManager()
    var locationLat:CLLocationDegrees?
    var locationLon:CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        contentView.applyShadow(cornerRadius: 20)
        
        mapView.delegate = self
        location.delegate = self
       
        self.getSchoolData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
        mapView.applyShadow(cornerRadius: 20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
    }
    
    @IBAction func editSchoolInfo(_ sender: Any) {
        if editStatus {
            updateView(state: true, hidden: false, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)) )
            editStatus = false
        }else{
            updateView(state: false, hidden: true, color: .white)
            editStatus = true
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateSchoolData()
        updateView(state: false, hidden: true, color: .white)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func detectLocationPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let nextVc = segue.destination as! MapVC
            nextVc.selectedLatitude = locationLat
            nextVc.selectedLongitude = locationLon
        }
    }
    
    func updateView(state: Bool, hidden: Bool, color: UIColor) {
        
        nameTxt.isUserInteractionEnabled = state
        schoolDescription.isUserInteractionEnabled = state
        phone.isUserInteractionEnabled = state
        
        saveBtn.isHidden = hidden
        cancelBtn.isHidden = hidden
        nameTxt.backgroundColor = color
        schoolDescription.backgroundColor = color
        phone.backgroundColor = color
        
        state ? editBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal) :
        editBtn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
    }
    
    
    //MARK: - firebase functions
    
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameTxt.text = documentSnapshot?.get("schoolName") as? String
                    self.schoolDescription.text = documentSnapshot?.get("schoolDescription") as? String ?? "لايوجد وصف"
                    self.phone.text = documentSnapshot?.get("schoolPhone") as? String ?? "لايوجد"
                    self.email.text = documentSnapshot?.get("schoolEmail") as? String
                    self.locationLbl.text =  documentSnapshot?.get("schoolLocation") as? String ?? "لم يحدد" + "الموقع"
                    let loca = documentSnapshot?.get("loca") as? [String: Any]
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
    
    func updateSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).updateData([
                "schoolName" : self.nameTxt.text ?? "مدرسة ...." ,
                "schoolDescription" : self.schoolDescription.text ?? "الوصف" ,
                "schoolPhone": self.phone.text ?? "لا يوجد" 
            ])
            {(error) in
                if error == nil {
                    print("update info  Succ..")
                }else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
}

