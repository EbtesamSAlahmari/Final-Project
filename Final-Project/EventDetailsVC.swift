//
//  EventDetailsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var eventOrganizerLbl: UILabel!
    @IBOutlet weak var eventDescriptionLbl: UITextView!
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityLbl: UILabel!
    @IBOutlet weak var eventKindLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var selectedEvent:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadEvent()
    }
    
    
    //MARK:  get specific documents from a collection
    func loadEvent() {
        db.collection("Users").whereField("eventName", isEqualTo: selectedEvent?.eventName).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.nameLbl.text = data["eventName"] as? String ?? "nil"
                    self.eventOrganizerLbl.text = data["eventOrganizer"] as? String ?? "nil"
                    self.eventDescriptionLbl.text = data["eventDescription"] as? String ?? "nil"
                    self.eventEmailLbl.text = data["eventEmail"] as? String ?? "nil"
                    self.eventCityLbl.text = data["eventCity"] as? String ?? "nil"
                    self.eventKindLbl.text = data["eventKind"] as? String ?? "nil"
                    
                }
                
            }
        }
    }
    

}

//    //MARK: - firebase function
//    func getEventData() {
//        if let userId = userId {
//            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
//                if let error = error {
//                    print("Error: ",error.localizedDescription)
//                }else {
//                    self.nameLbl.text = documentSnapshot?.get("eventName") as? String
//                    self.eventOrganizerLbl.text = documentSnapshot?.get("eventOrganizer") as? String
//                    self.eventDescriptionLbl.text = documentSnapshot?.get("eventDescription") as? String
//                    self.eventEmailLbl.text = documentSnapshot?.get("eventEmail") as? String
//                    self.eventCityLbl.text = documentSnapshot?.get("eventCity") as? String
//                    self.eventKindLbl.text = documentSnapshot?.get("eventKind") as? String
//
//                }
//            }
//        }
//    }
