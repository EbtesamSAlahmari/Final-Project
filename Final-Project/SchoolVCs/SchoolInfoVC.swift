//
//  SchoolInfoVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SchoolInfoVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var schoolDescription: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.getSchoolData()
        }
    }
    
    @IBAction func editSchoolInfo(_ sender: Any) {
        nameTxt.isUserInteractionEnabled = true
        schoolDescription.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
        
        saveBtn.isHidden = false
        cancelBtn.isHidden = false
        nameTxt.backgroundColor = .white
        schoolDescription.backgroundColor = .white
        phone.backgroundColor = .white
    }
    
    @IBAction func detectLocation(_ sender: Any) {
        
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateSchoolData()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - firebase functions
    
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameTxt.text = documentSnapshot?.get("schoolName") as? String
                    self.schoolDescription.text = documentSnapshot?.get("schoolDescription") as? String
                    self.phone.text = documentSnapshot?.get("schoolPhone") as? String
                    self.email.text = documentSnapshot?.get("schoolEmail") as? String
                    self.location.text = documentSnapshot?.get("schoolLocation") as? String
                }
            }
        }
    }
    
    func updateSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).updateData([
                "schoolName" : self.nameTxt.text ?? "مدرسة ...." ,
                "schoolDescription" : self.schoolDescription.text ?? "الوصف" ,
                "schoolPhone": self.phone.text ?? "لا يوجد" 
            ])
            {(error) in
                if error == nil {
                    print("update info  Succ..")
                }else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
}

