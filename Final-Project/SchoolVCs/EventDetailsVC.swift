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
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var compactDatePicker: UIDatePicker!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var contView: UIView!
    @IBOutlet weak var sendRequestBtn: UIButton!
    @IBOutlet weak var eventDescriptionLbl: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var secondSubView: UIView!
    @IBOutlet weak var isOneDay: UISwitch!
    @IBOutlet weak var fromDateStack: UIStackView!
    @IBOutlet weak var toLbl: UILabel!
    
    var selectedEvent:Event?
    var selectedRequestEvent:RequestEvent?
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var schoolName = ""
    var selectedDate = ""
    var startDateStr:String?
    var endDateStr:String?
    var startDate:Date?
    var endDate:Date?
    var days = 1
    var oneDay = false
    var totalPrice:Double?
    var imageStr = ""
    var schoolRequestTotalPrice = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        contView.layer.cornerRadius = 30
        contView.clipsToBounds = true
        subView.applyShadow(cornerRadius: 20)
        secondSubView.applyShadow(cornerRadius: 20)
        navigationController?.hidesBarsOnSwipe = true
    }
   
    override func viewWillAppear(_ animated: Bool) {
        //getSchoolRequestID()
        getSchoolData()
        //event info
        self.nameLbl.text = selectedEvent?.eventName
        self.eventOrganizerLbl.text = selectedEvent?.eventOrganizer
        self.eventDescriptionLbl.text = selectedEvent?.eventDescription
        self.eventEmailLbl.text = selectedEvent?.eventEmail
        self.eventCityLbl.text = selectedEvent?.eventCity
        self.eventPrice.text = "\(selectedEvent?.eventPrice ?? 0)" + "ريال" + " /يوم"
        let imgStr = selectedEvent?.eventImage
        if imgStr == "nil" {
            self.eventImage.image = UIImage(systemName: "photo")
        }
        else {
            self.loadImage(imgStr: imgStr ?? "nil" )
            self.imageStr = imgStr ?? "nil"
        }
//        if vcNum == 2 {
//            getEventData()
//            sendRequestBtn.isHidden = true
//        }
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        self.view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        startDate = sender.date
        startDateStr = dateFormatter.string(from: startDate!)
        
    }
    
    @IBAction func endDatePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        endDate = sender.date
        endDateStr = dateFormatter.string(from: endDate!)
        
        let calendar = NSCalendar.current
        if oneDay == true {
            startDateStr = dateFormatter.string(from: endDate!)
            totalPrice = (selectedEvent?.eventPrice)! * 1
        }
        else {
        let diffInDays = calendar.dateComponents([.day], from: calendar.startOfDay(for: startDate!) , to: calendar.startOfDay(for: endDate!)).day!
        days = diffInDays + 1
        totalPrice = (selectedEvent?.eventPrice)! * Double(days)
        }
        DispatchQueue.main.async {
            self.totalPriceLbl.text = "\(self.totalPrice!)"
        }
    }
   
    @IBAction func isOneDayAction(_ sender: UISwitch) {
        if isOneDay.isOn {
            fromDateStack.isHidden = true
            toLbl.isHidden = true
            oneDay = true
        }else {
            fromDateStack.isHidden = false
            toLbl.isHidden = false
            oneDay = false
        }
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
            "startDate" : startDateStr ?? "لم يحدد" ,
            "endDate" : endDateStr ?? "لم يحدد" ,
            //"date": selectedDate ?? "لم يحدد",
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
            if let error = error {
                print("Error: Image could not download!")
                print("===================")
                print(error.localizedDescription)
                
            } else {
                self.eventImage.image = UIImage(data: data!)
            }
        }
    }
    
    
    
//
//    func getEventData() {
//        db.collection("Users").whereField("eventID", isEqualTo: (selectedRequestEvent?.eventID)!).getDocuments {
//            querySnapshot, error in
//            if let error = error {
//                print("Error: ",error.localizedDescription)
//            }else {
//                for document in querySnapshot!.documents {
//                    let data = document.data()
//                    self.nameLbl.text = data["eventName"] as? String ?? "لم يحدد"
//                    self.eventOrganizerLbl.text = data["eventOrganizer"] as? String ?? "لم يحدد"
//                    self.eventDescriptionLbl.text =  data["eventDescription"] as? String ?? "لايوجد"
//                    self.eventEmailLbl.text = data["eventEmail"] as? String ?? "nil"
//                    self.eventCityLbl.text = data["eventCity"] as? String ?? "لم يحدد"
//                    self.eventPrice.text = "\(data["eventPrice"] as? Double  ?? 0)" + "ريال" + " لليوم الواحد"
//                    self.totalPriceLbl.text = "\((self.selectedRequestEvent?.totalPrice)!)" + "ريال "
//                    let eventImage =  data["eventImage"] as? String ?? "nil"
//                    if eventImage == "nil" {
//                        self.eventImage.image = UIImage(systemName: "photo")
//                    }
//                    else {
//                        self.loadImage(imgStr: eventImage ?? "nil" )
//                        self.imageStr = eventImage ?? "nil"
//                    }
//                }
//            }
//        }
//    }

}


