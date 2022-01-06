//
//  RequestVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class RequestsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var requests = [RequestEvent]()
    var selectedRequest:RequestEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSchoolRequest()
        
    }
    
    //MARK: - firebase function
    func getSchoolRequest() {
        if let userId = userId {
            
            db.collection("Requests").whereField("eventID", isEqualTo: userId).getDocuments { querySnapshot, error in
                self.requests = []
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let requestStatus = data["requestStatus"] as? String ?? "nil"
                        if requestStatus == "انتظار" {
                            let requestID = data["requestID"] as? String ?? "nil"
                            let schoolID = data["schoolID"] as? String ?? "nil"
                            let schoolName = data["schoolName"] as? String ?? "nil"
                            let eventName = data["eventName"] as? String ?? "nil"
                            let eventOrganizer = data["eventOrganizer"] as? String ?? "nil"
                            
                            let date = data["date"] as? Date ?? Date()
                            let time = data["time"] as? String ?? "nil"
                            let duration = data["duration"] as? String ?? "nil"
                            let budget = data["budget"] as? String ?? "nil"
                            let newRequest = RequestEvent(eventID: userId , schoolID: schoolID, requestID: requestID, eventName: eventName, schoolName: schoolName , eventOrganizer: eventOrganizer, date: date, time: time, duration: duration, budget: budget, requestStatus: requestStatus)
                            self.requests.append(newRequest)
                        }
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


//MARK: -UITableViewDelegate, UITableViewDataSource
extension RequestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolRequestCell") as! SchoolRequestCell
            cell.schoolName.text = requests[indexPath.row].schoolName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRequest = requests[indexPath.row]
         performSegue(withIdentifier: "moreRequestDetails", sender: nil)
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "moreRequestDetails" {
                let nextVc = segue.destination as! RequestDetailsVC
                nextVc.selectedRequest = selectedRequest
            }
        }
}

//MARK: -UITableView
extension UITableView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


