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
                    }
                }
            }
        }
    }
}


//MARK: -UITableView
extension RequestsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requests.isEmpty {
           return 1
        }else {
        return requests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schoolRequestCell") as! SchoolRequestCell
        if requests.isEmpty {
            cell.schoolName.text =  "لا يوجد طلبات"
            cell.schoolName.textColor = .gray
            cell.icon.isHidden = true
        }else {
            cell.schoolName.text = requests[indexPath.row].schoolName
            cell.schoolName.textColor = .black
            cell.icon.isHidden = false
        }
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






//    func getEventData() {
//        if let userId = userId {
//            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
//                if let error = error {
//                    print("Error: ",error.localizedDescription)
//                }else {
//                    self.eventOrganizer = documentSnapshot?.get("eventOrganizer") as? String ?? "nil"
//                    self.getSchoolRequest()
//                }
//            }
//        }
//    }
//



//  func getSchoolRequest() {
//        if let userId = userId {
//            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
//                self.schoolRequest = []
//                if let error = error {
//                    print("Error: ",error.localizedDescription)
//                }else {
//                    self.nameLbl.text = documentSnapshot?.get("schoolName") as? String
//                    self.descriptionLbl.text = documentSnapshot?.get("schoolDescription") as? String
//                    self.locationLbl.text = documentSnapshot?.get("schoolLocation") as? String
//                    let schoolRequest = documentSnapshot?.data()?["requests"] as! [[String:Any]]
//                        for request in schoolRequest {
//                            let eventName =  request["eventName"] as? String ?? "nil"
//                            let eventOrganizer =  request["eventOrganizer"] as? String ?? "nil"
//                            let date =  request["date"] as? Date ?? Date()
//                            let time =  request["time"] as? String ?? "nil"
//                            let duration =  request["duration"] as? String ?? "nil"
//                            let budget =  request["budget"] as? String ?? "nil"
//                            let requestStatus =  request["requestStatus"] as? String ?? "nil"
//                            let newRequest = Request(requestID: "" , eventName: eventName, eventOrganizer: eventOrganizer, date: date, time: time, duration: duration, budget: budget, requestStatus: requestStatus)
//                            self.requests.append(newRequest)
//                            print("----",self.requests)
//                        }
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }


//       db.collection("Users").whereField("type", isEqualTo: "school" ).getDocuments { querySnapshot, error in
//         self.schoolRequests = []
//           self.requests = []
//           if let error = error {
//               print("Error: ",error.localizedDescription)
//           }else {
//               for document in querySnapshot!.documents {
//                   let data = document.data()
////                   let schoolName = data["schoolName"] as? String ?? "nil"
////                   let schoolDescription = data["schoolDescription"] as? String
////                   let schoolPhone = data["schoolPhone"] as? String
////                   let schoolEmail = data["schoolEmail"] as? String
////                   let schoolLocation = data["schoolLocation"] as? String
//                   let schoolRequest = data["requests"] as! [[String:Any]]
//                   for request in schoolRequest {
//                       let requestID =  request["requestID"] as? String ?? "nil"
//                       print("----",requestID)
//                       print("++++++",self.userId!)
//                     //  if requestID == self.userId! {
//                           let eventName =  request["eventName"] as? String ?? "nil"
//                           let eventOrganizer =  request["eventOrganizer"] as? String ?? "nil"
//                           let date =  request["date"] as? Date ?? Date()
//                           let time =  request["time"] as? String ?? "nil"
//                           let duration =  request["duration"] as? String ?? "nil"
//                           let budget =  request["budget"] as? String ?? "niRl"
//                           let requestStatus =  request["requestStatus"] as? String ?? "nil"
//                           let newRequest = Request(requestID: requestID , eventName: eventName, eventOrganizer: eventOrganizer, date: date, time: time, duration: duration, budget: budget, requestStatus: requestStatus)
//                           self.requests.append(newRequest)
//                           print("----",self.requests)
//                      // }
//                   }
//
////                   let newArr = School(type: "school", schoolName: schoolName, schoolDescription: schoolDescription, schoolPhone: schoolPhone, schoolEmail: schoolEmail, schoolLocation: schoolLocation, requests: self.requests)
////                   self.schoolRequests.append(newArr)
////                   print("----",self.schoolRequests)
//               }
//               self.requests = self.requests.filter({ $0.requestID == "c3XCOonQW6ZnWgrLRWxajiG8UbP2"})
//               print("+++++",self.requests)
//
//               DispatchQueue.main.async {
//                   self.tableView.reloadData()
//               }
//           }
//       }
//
//
//   }

