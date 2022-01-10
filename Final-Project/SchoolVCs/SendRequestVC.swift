////
////  SendRequestVC.swift
////  Final-Project
////
////  Created by Ebtesam Alahmari on 04/01/2022.
////
//
//import UIKit
//import Firebase
//import FirebaseFirestore
//
//class SendRequestVC: UIViewController {
//
//    @IBOutlet weak var dateTxt: UITextField!
//   
//    let db = Firestore.firestore()
//    var userId = Auth.auth().currentUser?.uid
//    var selectedEvent:Event?
//    var schoolName = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        getSchoolData()
//    }
//    
//    @IBAction func sendRequestPressed(_ sender: UIButton) {
//        addRequest()
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarS") as! UITabBarController
//       self.present(vc, animated: true, completion: nil)
//    }
//    
//    
//    //MARK: - firebase function
//    func addRequest() {
//        let Ref = self.db.collection("Requests")
//        let Doc = Ref.document()
//        print("Doc",Doc.documentID)
//        let requestData = [
//            "requestID":Doc.documentID ,
//            "eventID": selectedEvent?.eventID,
//            "schoolID": userId!,
//            "eventName": selectedEvent?.eventName,
//            "schoolName": schoolName,
//            "eventOrganizer": selectedEvent?.eventOrganizer,
//            "date": self.dateTxt.text ?? "لم يحدد",
//            "time": self.timeTxt.text ?? "لم يحدد" ,
//            //-----
//            "budget": "لم يحدد",
//            
//            "requestStatus": "انتظار"
//        ]
//        Doc.setData(requestData) { error in
//            if let error = error {
//                print("Error: ",error.localizedDescription)
//            }else {
//                print("new request has created..")
//            }
//        }
//    }
//    
//    func getSchoolData() {
//        if let userId = userId {
//            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
//                if let error = error {
//                    print("Error: ",error.localizedDescription)
//                }else {
//                    self.schoolName = documentSnapshot?.get("schoolName") as? String ?? "nil"
//                }
//            }
//        }
//    }
//}
//
