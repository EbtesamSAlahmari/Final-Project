//
//  VisitsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore



class VisitsVC: UIViewController, UIScrollViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var visits = [RequestEvent]()
    var selectedRequest:RequestEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        topView.applyShadow(cornerRadius: 40)
        getSchoolVisit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
                            let startDate = data["startDate"] as? String ?? "لم يحدد"
                            let endDate = data["endDate"]as? String ?? "لم يحدد"
                            let totalPrice = data["totalPrice"] as? Double ?? 0
                            let newRequest = RequestEvent(eventID: userId , schoolID: schoolID, requestID: requestID, eventName: eventName, schoolName: schoolName , eventOrganizer: eventOrganizer,startDate: startDate, endDate: endDate, totalPrice: totalPrice, requestStatus: requestStatus)
                            self.visits.append(newRequest)
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



//MARK: -UITableView
extension VisitsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if !visits.isEmpty
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            self.tableView.setEmptyMessage("لايوجد زيارات")
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        visits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventVisitCell") as! EventVisitCell
        cell.schoolName.text = visits[indexPath.row].schoolName
        cell.visitDate.text = visits[indexPath.row].startDate! + "-" +  visits[indexPath.row].endDate!
        cell.visitPrice.text = "\(visits[indexPath.row].totalPrice!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
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


















