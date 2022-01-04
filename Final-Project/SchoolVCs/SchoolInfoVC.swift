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
        getSchoolData()
        
    }
    
    @IBAction func editSchoolInfo(_ sender: Any) {
        nameTxt.isUserInteractionEnabled = true
        schoolDescription.isUserInteractionEnabled = true
        phone.isUserInteractionEnabled = true
       // email.isUserInteractionEnabled = true
        
        saveBtn.isHidden = false
        cancelBtn.isHidden = false
        nameTxt.backgroundColor = .white
        schoolDescription.backgroundColor = .white
        phone.backgroundColor = .white
       // email.backgroundColor = .white
        
    }
    
    @IBAction func detectLocation(_ sender: Any) {
        
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        updateSchoolData()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
                }
            }
        }
    }
    
    func updateSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).updateData([
                "schoolName" : self.nameTxt.text ?? "مدرسة ...." ,
                "schoolDescription" : self.schoolDescription.text ?? "الوصف" ,
                "schoolPhone": self.phone.text ?? "لا يوجد" ,
                "schoolLocation" : self.location.text ?? "لم يحدد"
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




//func getData()  {
//    db.collection("Posts").order(by: "postDate", descending: true).addSnapshotListener { querySnapshot, error in
//        self.posts = []
//        if let error = error {
//            print("Error: ",error.localizedDescription)
//        }else {
//            for document in querySnapshot!.documents {
//                let data = document.data()
//                let newPost = Post(name: data["name"] as? String ?? "nil", userName: data["userName"] as? String ?? "nil", userIcon: data["userIcon"] as? String ?? "nil", postDate: data["postDate"] as? Date ?? Date(), postImage: data["postImage"] as? String ?? "nil" , message: data["message"] as? String ?? "nil")
//                self.posts.append(newPost)
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//}
