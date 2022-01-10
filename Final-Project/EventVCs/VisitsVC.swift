//
//  VisitsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class VisitsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var visits = [RequestEvent]()
    var selectedRequest:RequestEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getSchoolVisit()
    }
    
    //MARK: - firebase function
    func getSchoolVisit() {
        if let userId = userId {
            
            db.collection("Requests").whereField("eventID", isEqualTo: userId).getDocuments { querySnapshot, error in
                self.visits = []
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let requestStatus = data["requestStatus"] as? String ?? "nil"
                        if requestStatus == "مقبولة" {
                            let requestID = data["requestID"] as? String ?? "nil"
                            let schoolID = data["schoolID"] as? String ?? "nil"
                            let schoolName = data["schoolName"] as? String ?? "nil"
                            let eventName = data["eventName"] as? String ?? "nil"
                            let eventOrganizer = data["eventOrganizer"] as? String ?? "nil"
                            
                            let date = data["date"] as? String ?? "لم يحدد"
                            let time = data["time"] as? String ?? "nil"
                            let duration = data["duration"] as? String ?? "nil"
                            let budget = data["budget"] as? String ?? "nil"
                            let newRequest = RequestEvent(eventID: userId , schoolID: schoolID, requestID: requestID, eventName: eventName, schoolName: schoolName , eventOrganizer: eventOrganizer, date: date, time: time, duration: duration, budget: budget, requestStatus: requestStatus)
                            self.visits.append(newRequest)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.visits.isEmpty {
                            self.tableView.setEmptyMessage("لايوجد زيارات")
                        }
                    }
                }
            }
        }
    }
}



//MARK: -UITableView
extension VisitsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventVisitCell") as! EventVisitCell
        cell.schoolName.text = visits[indexPath.row].schoolName
        cell.visitDate.text = visits[indexPath.row].date
        cell.visitBudget.text = visits[indexPath.row].budget
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRequest = visits[indexPath.row]
        performSegue(withIdentifier: "Details", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            let nextVc = segue.destination as! RequestDetailsVC
            nextVc.selectedRequest = selectedRequest
            nextVc.vcNum = 2
        }
    }
}
