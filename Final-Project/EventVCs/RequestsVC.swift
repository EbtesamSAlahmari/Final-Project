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
    @IBOutlet weak var topView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var requests = [RequestEvent]()
    var selectedRequest:RequestEvent?
    var backgroundView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        topView.applyShadow(cornerRadius: 40)
        getSchoolRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - firebase function
    func getSchoolRequest() {
        //  .order(by: "requestDate", descending: true)
        if let userId = userId {
            db.collection("Requests").whereField("eventID", isEqualTo: userId).addSnapshotListener { querySnapshot, error in
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
                            let totalPrice = data["totalPrice"] as? Double ?? 0
                            let startDate = data["startDate"] as? String ?? "لم يحدد"
                            let endDate = data["endDate"]as? String ?? "لم يحدد"
                            let newRequest = RequestEvent(eventID: userId , schoolID: schoolID, requestID: requestID, eventName: eventName, schoolName: schoolName , eventOrganizer: eventOrganizer, startDate: startDate, endDate: endDate, totalPrice: totalPrice, requestStatus: requestStatus)
                            self.requests.append(newRequest)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}


//MARK: -UITableViewDelegate, UITableViewDataSource
extension RequestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if !requests.isEmpty
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            self.tableView.setEmptyMessage("لايوجد طلبات")
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolRequestCell") as! SchoolRequestCell
        cell.viewCell.applyShadow(cornerRadius: 20)
        cell.schoolName.text = requests[indexPath.row].schoolName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
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


