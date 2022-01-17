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
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    
    var selectedEvent:Event?
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var schoolName = ""
    var selectedDate = ""
    var startDate:Date?
    var endDate:Date?
    var days = 1
    var totalPrice:Double?
    var imageStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        contView.layer.cornerRadius = 30
        contView.clipsToBounds = true
        
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

        let imgStr = selectedEvent?.eventImage
        if imgStr == "nil" {
            self.eventImage.image = UIImage(systemName: "photo")
        }
        else {
            self.loadImage(imgStr: imgStr ?? "nil" )
            self.imageStr = imgStr ?? "nil"
        }
        
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        startDate = sender.date
        selectedDate = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func endDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        endDate = sender.date
        let calendar = NSCalendar.current
        let diffInDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate!) , to: calendar.startOfDay(for: endDate!)).day!
        days = diffInDays + 1
        selectedDate = dateFormatter.string(from: startDate!) + " - " +  dateFormatter.string(from: endDate!)   // "\(startDate!)" + "\(endDate!)"
        totalPrice = (selectedEvent?.eventPrice)! * Double(days)
        DispatchQueue.main.async {
            self.totalPriceLbl.text = "\(self.totalPrice!)"
        }
        
       //dateFormatter.string(from: sender.date)
    }
   
    
    @IBAction func requestPressed(_ sender: Any) {
        addRequest()
        navigationController?.popViewController(animated: true)
    }

    
 
    
    //MARK: - firebase function
    func addRequest() {
        let Ref = self.db.collection("Requests")
        let Doc = Ref.document()
        print("Doc",Doc.documentID)
        let requestData = [
            "requestDate" : Timestamp(),
            "requestID": Doc.documentID ,
            "eventID": selectedEvent?.eventID,
            "schoolID": userId!,
            "eventName": selectedEvent?.eventName,
            "schoolName": schoolName,
            "eventOrganizer": selectedEvent?.eventOrganizer,
            "date": selectedDate ?? "لم يحدد",
            "totalPrice": totalPrice ,
            "requestStatus": "انتظار"
        ] as [String : Any]
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
    
    func loadImage(imgStr: String) {
        let url = "gs://final-project-e67fe.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
                print("===================")
                print(error?.localizedDescription)
                
            } else {
                self.eventImage.image = UIImage(data: data!)
            }
        }
    }
    
}

