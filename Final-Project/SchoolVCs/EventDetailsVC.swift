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
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventPrice: UILabel!
    
    @IBOutlet weak var compactDatePicker: UIDatePicker!
    @IBOutlet weak var totalPrice: UILabel!
    
    
    var selectedEvent:Event?
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var schoolName = ""
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        selectedDate = dateFormatter.string(from: sender.date)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        getSchoolData()
        //event info
        self.nameLbl.text = selectedEvent?.eventName
        self.eventOrganizerLbl.text = selectedEvent?.eventOrganizer
        self.eventDescriptionLbl.text = selectedEvent?.eventDescription
        self.eventEmailLbl.text = selectedEvent?.eventEmail
        self.eventCityLbl.text = selectedEvent?.eventCity
        self.eventPrice.text = "\(selectedEvent?.eventPrice ?? 0)" + "ريال" + " لليوم الواحد"
    }
    
    @IBAction func requestPressed(_ sender: Any) {
        //performSegue(withIdentifier: "toSendRequest", sender: nil)
        addRequest()
        navigationController?.popViewController(animated: true)
    }
    
    
 
    
    //MARK: - firebase function
    func addRequest() {
        let Ref = self.db.collection("Requests")
        let Doc = Ref.document()
        print("Doc",Doc.documentID)
        let requestData = [
            "requestID":Doc.documentID ,
            "eventID": selectedEvent?.eventID,
            "schoolID": userId!,
            "eventName": selectedEvent?.eventName,
            "schoolName": schoolName,
            "eventOrganizer": selectedEvent?.eventOrganizer,
            "date": selectedDate ?? "لم يحدد",
            //-----
            "budget": "لم يحدد",
            
            "requestStatus": "انتظار"
        ]
        Doc.setData(requestData) { error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                print("new request has created..")
            }
        }
    }
    
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.schoolName = documentSnapshot?.get("schoolName") as? String ?? "nil"
                }
            }
        }
    }
    
}

