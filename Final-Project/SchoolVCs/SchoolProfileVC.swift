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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var schools = [School]()
    var requests = [RequestEvent]()
   lazy var alterRequests = [RequestEvent]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        contentView.applyShadow(cornerRadius: 40)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        getSchoolData()
        getRequest()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
       
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        requests = alterRequests
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
        tableView.reloadData()
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
                }
            }
        }
    }
    
    func getRequest() {
        if let userId = userId {
            db.collection("Requests").order(by: "requestDate", descending: true).whereField("schoolID", isEqualTo: userId).addSnapshotListener { querySnapshot, error in
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
                        let date = data["date"] as? String ?? "لم يحدد"
                        let totalPrice = data["totalPrice"] as? Double ?? 0
                        let newRequest = RequestEvent( eventID: eventID, schoolID: userId, requestID: requestID, eventName: eventName, eventOrganizer: eventOrganizer, date: date,totalPrice: totalPrice, requestStatus: requestStatus)
                        self.requests.append(newRequest)
                        self.alterRequests = self.requests
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    if self.requests.isEmpty {
                        self.tableView.setEmptyMessage("لايوجد طلبات")
                    }
                    
                    }
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
        switch requests[indexPath.row].requestStatus {
        case "انتظار":
            cell.eventStatusLbl.textColor = UIColor(#colorLiteral(red: 0.9688981175, green: 0.8095123768, blue: 0.3056389093, alpha: 1))
        case "مقبولة":
            cell.eventStatusLbl.textColor = UIColor(#colorLiteral(red: 0.2493973076, green: 0.7426506877, blue: 0.7891102433, alpha: 1))
        case "مرفوضة":
            cell.eventStatusLbl.textColor = UIColor(#colorLiteral(red: 0.9845072627, green: 0.3404255509, blue: 0.02565482073, alpha: 1))
        case "منتهية":
            cell.eventStatusLbl.textColor = UIColor(#colorLiteral(red: 0.7315554023, green: 0.7650949955, blue: 0.8251858354, alpha: 1))
        default:
            cell.eventStatusLbl.textColor = UIColor(#colorLiteral(red: 0.2493973076, green: 0.7426506877, blue: 0.7891102433, alpha: 1))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
