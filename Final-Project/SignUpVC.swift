//
//  SignUpVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var rePasswordTxt: UITextField!
    @IBOutlet weak var schoolType: UIButton!
    @IBOutlet weak var eventType: UIButton!
    
    let db = Firestore.firestore()
    var selectedType = "event"
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTxt.text!, password: passwordTxt.text!) { user, error in
            if let error = error {
                let alert = UIAlertController(title: "تنبيه", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                if self.selectedType == "school" {
                    self.addSchool(documentId:(user?.user.uid)!)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarS") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }else {
                    self.addEvent(documentId:(user?.user.uid)!)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarE") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func privacyPolicyPressed(_ sender: Any) {
        
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "signInVC") as! SignInVC
        present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func schoolChoice(_ sender: UIButton) {
        changeStatusBtn(sender)
        eventType.setImage(UIImage(systemName: "squareshape"), for: .normal)
        selectedType = "school"
    }
    
    @IBAction func eventChoice(_ sender: UIButton) {
        changeStatusBtn(sender)
        selectedType = "event"
        schoolType.setImage(UIImage(systemName: "squareshape"), for: .normal)
    }
    
    func changeStatusBtn(_ button: UIButton) {
        if button.currentImage == UIImage(systemName: "squareshape") {
            button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            
        }else {
            button.setImage(UIImage(systemName: "squareshape"), for: .normal)
        }
    }
    
    
    
    func addSchool(documentId: String) {
        db.collection("Users").document(documentId).setData(
            [
                "type": "school",
                "schoolID": documentId,
                "schoolName": nameTxt.text ?? "مدرسة....",
                "schoolDescription": "",
                "schoolPhone": "",
                "schoolEmail": emailTxt.text! ,
                "schoolLocation": ""
            ]
        )
        {(error) in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                print("new school has created..")
            }
        }
    }
    
    
    func addEvent(documentId: String) {
        db.collection("Users").document(documentId).setData(
            [
                "type": "event",
                "eventID": documentId,
                "eventName": nameTxt.text ?? "فعالية....",
                "eventOrganizer": "",
                "eventDescription": "",
                "eventEmail": emailTxt.text! ,
                "eventCity": "",
                "eventKind": "",
                "eventImage": ""
            ]
        )
        {(error) in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                print("new event has created..")
            }
        }
    }
}



