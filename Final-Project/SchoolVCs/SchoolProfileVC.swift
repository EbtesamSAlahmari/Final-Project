//
//  SchoolProfileVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SchoolProfileVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var schools = [School]()
    var requests = [RequestEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSchoolData()
        getRequest()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
       getRequest()
        switch sender.selectedSegmentIndex
        {
        case 0:
            requests = requests.filter({$0.requestStatus == "منتهية" })
        case 1:
            requests = requests.filter({$0.requestStatus == "مرفوضة" })
        case 2:
            requests = requests.filter({$0.requestStatus == "مقبولة" })
        case 3:
            requests = requests.filter({$0.requestStatus == "انتظار" })
        case 4:
            getRequest()
        default:
            break
        }
        self.tableView.reloadData()
    }
    
    //MARK: - firebase functions
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameLbl.text = documentSnapshot?.get("schoolName") as? String
                    self.descriptionLbl.text = documentSnapshot?.get("schoolDescription") as? String
                    self.locationLbl.text = documentSnapshot?.get("schoolLocation") as? String
                }
            }
        }
    }
    
    func getRequest() {
        if let userId = userId {
            db.collection("Requests").whereField("schoolID", isEqualTo: userId).getDocuments { querySnapshot, error in
                self.requests = []
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let eventID = data["eventID"] as? String ?? "nil"
                        let requestID = data["requestID"] as? String ?? "nil"
                        let eventName = data["eventName"] as? String ?? "nil"
                        let eventOrganizer = data["eventOrganizer"] as? String ?? "nil"
                        let requestStatus = data["requestStatus"] as? String ?? "nil"
                        let date = data["date"] as? Date ?? Date()
                        let time = data["time"] as? String ?? "nil"
                        let duration = data["duration"] as? String ?? "nil"
                        let budget = data["budget"] as? String ?? "nil"
                        let newRequest = RequestEvent( eventID: eventID, schoolID: userId, requestID: requestID, eventName: eventName, eventOrganizer: eventOrganizer, date: date, time: time, duration: duration, budget: budget, requestStatus: requestStatus)
                        self.requests.append(newRequest)
                    }
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
                }
            }
        }
    }
}

//MARK: -UITableView
extension SchoolProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCell
        
        cell.eventNameLbl.text = requests[indexPath.row].eventName
        cell.eventTeamLbl.text = requests[indexPath.row].eventOrganizer
        cell.eventStatusLbl.text = requests[indexPath.row].requestStatus
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}
