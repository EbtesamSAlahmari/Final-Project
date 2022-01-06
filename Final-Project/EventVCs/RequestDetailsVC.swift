//
//  RequestDetailsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 05/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class RequestDetailsVC: UIViewController {

    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var schoolDescription: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var timeTxt: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var acceptRequestBtn: UIButton!
    @IBOutlet weak var refuseRequestBtn: UIButton!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var selectedRequest:RequestEvent?
    var requestStatus = ""
    var vcNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRequest()
        nameTxt.text = selectedRequest?.schoolName
        
        //dateTxt.text = String(selectedRequest?.date)
        timeTxt.text = selectedRequest?.time
        duration.text = selectedRequest?.duration
        budget.text = selectedRequest?.budget
        
        if vcNum == 2 {
            acceptRequestBtn.isHidden = true
            refuseRequestBtn.isHidden = true
        }
        
    }
    
    @IBAction func acceptRequestPressed(_ sender: Any) {
        updateRequestStatus(status: "مقبولة")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarE") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func refuseRequestPressed(_ sender: Any) {
        updateRequestStatus(status: "مرفوضة")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarE") as! UITabBarController
        self.present(vc, animated: true, completion: nil)
    }
    
 
//MARK:  -get specific documents from a collection
    func loadRequest() {
        db.collection("Users").whereField("schoolID", isEqualTo: (selectedRequest?.schoolID)!).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                   // self.nameTxt.text = data["schoolName"] as? String ?? "nil"
                    self.schoolDescription.text = data["schoolDescription"] as? String ?? "nil"
                    self.phone.text = data["schoolPhone"] as? String ?? "nil"
                    self.email.text = data["schoolEmail"] as? String ?? "nil"
                }
                
            }
        }
    }
    
    func updateRequestStatus(status: String) {
        if let userId = userId {
            db.collection("Requests").whereField("requestID", isEqualTo: (selectedRequest?.requestID)!).getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    for document in querySnapshot!.documents {
                        if document == document {
                            self.db.collection("Requests").document(document.documentID).updateData(["requestStatus" : status]) { error in
                                    if error == nil {
                                        print("update requestStatus  Succ..")
                                    }else {
                                        print(error!.localizedDescription)
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
}



