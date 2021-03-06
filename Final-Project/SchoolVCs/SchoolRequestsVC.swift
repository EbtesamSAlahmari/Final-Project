//
//  SchoolRequestsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 19/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD

class SchoolRequestsVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var eventOrganizerLbl: UILabel!
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var startDateLbl: UILabel!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var eventDescriptionLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var secondSubView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var selectedEvent:Event?
    var selectedRequestEvent:RequestEvent?
    var imageStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        contView.layer.cornerRadius = 30
        contView.clipsToBounds = true
        subView.applyShadow(cornerRadius: 20)
        secondSubView.applyShadow(cornerRadius: 20)
        
        navigationController?.hidesBarsOnSwipe = true
        
        getEventData()
        ProgressHUD.colorHUD = .darkGray
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorHUD = UIColor.clear
        ProgressHUD.show("", interaction: false)
    }
    
    func getEventData() {
        db.collection("Users").whereField("eventID", isEqualTo: (selectedRequestEvent?.eventID)!).getDocuments {
            querySnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.nameLbl.text = data["eventName"] as? String ?? "???? ????????"
                    self.eventOrganizerLbl.text = data["eventOrganizer"] as? String ?? "???? ????????"
                    self.eventDescriptionLbl.text =  data["eventDescription"] as? String ?? "????????????"
                    self.eventEmailLbl.text = data["eventEmail"] as? String ?? "nil"
                    self.eventCityLbl.text = data["eventCity"] as? String ?? "???? ????????"
                    self.eventPrice.text = "\(data["eventPrice"] as? Double  ?? 0)" + "????????" + " /?????????? ????????????"
                    self.totalPriceLbl.text = "\((self.selectedRequestEvent?.totalPrice)!)" + "???????? "
                    self.startDateLbl.text = self.selectedRequestEvent?.startDate
                    self.endDateLbl.text = self.selectedRequestEvent?.endDate
                    let eventImage =  data["eventImage"] as? String ?? "nil"
                    if eventImage == "nil" {
                        self.eventImage.image = UIImage(systemName: "photo")
                    }
                    else {
                        self.loadImage(imgStr: eventImage ?? "nil" )
                        self.imageStr = eventImage ?? "nil"
                    }
                }
            }
        }
    }
    
    func loadImage(imgStr: String) {
        let url = "gs://final-project-e67fe.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error: Image could not download!")
                print(error.localizedDescription)
            } else {
                self.eventImage.image = UIImage(data: data!)
                ProgressHUD.dismiss()
            }
        }
    }
}
