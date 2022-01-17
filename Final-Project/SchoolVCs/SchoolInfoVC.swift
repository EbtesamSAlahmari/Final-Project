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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editBtn: UIButton!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var editStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        contentView.applyShadow(cornerRadius: 20)
        DispatchQueue.main.async {
            self.getSchoolData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
    }
    
    @IBAction func editSchoolInfo(_ sender: Any) {
        if editStatus {
            updateView(state: true, hidden: false, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 1)))
            editStatus = false
        }else{
            updateView(state: false, hidden: true, color: .white)
            editStatus = true
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateSchoolData()
        updateView(state: false, hidden: true, color: .white)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func updateView(state: Bool, hidden: Bool, color: UIColor) {
        
        nameTxt.isUserInteractionEnabled = state
        schoolDescription.isUserInteractionEnabled = state
        phone.isUserInteractionEnabled = state
        
        saveBtn.isHidden = hidden
        cancelBtn.isHidden = hidden
        nameTxt.backgroundColor = color
        schoolDescription.backgroundColor = color
        phone.backgroundColor = color
        
        state ? editBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal) :
        editBtn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
    }
    
    
    //MARK: - firebase functions
    
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameTxt.text = documentSnapshot?.get("schoolName") as? String
                    self.schoolDescription.text = documentSnapshot?.get("schoolDescription") as? String ?? "لايوجد وصف"
                    self.phone.text = documentSnapshot?.get("schoolPhone") as? String ?? "لايوجد"
                    self.email.text = documentSnapshot?.get("schoolEmail") as? String
                    self.location.text = documentSnapshot?.get("schoolLocation") as? String ?? "لم يحدد"
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

