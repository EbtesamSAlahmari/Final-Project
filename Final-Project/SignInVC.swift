//
//  ViewController.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.setLeftImage(imageName: "envelope")
        passwordTxt.setLeftImage(imageName: "lock")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.getData(Auth.auth().currentUser!.uid)
        }
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTxt.text!, password: passwordTxt.text! , completion: { user, error in
            if let error = error {
                let alert = UIAlertController(title: "تنبيه", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "حسناً", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let userId = user?.user.uid
                self.getData(userId!)
            }
        })
    }
    
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        var textFieldEmail = UITextField()
        let alert = UIAlertController(title: "إعادة تعيين كلمة المرور", message: "الرجاء إدخال البريد الإلكتروني لإعادة تعيين كلمة المرور", preferredStyle: .alert)
        alert.addTextField { alartTextField in
            alartTextField.placeholder = "ادخل البريد الالكتروني"
            alartTextField.textAlignment = .right
            textFieldEmail = alartTextField
        }
        let OkBtu = UIAlertAction(title: "حسنا", style: .default) { action in
            Auth.auth().sendPasswordReset(withEmail: textFieldEmail.text!) { error in
                if let error = error {
                    let alert2 = UIAlertController(title: "لم تتم إعادة التعيين", message: error.localizedDescription, preferredStyle: .alert)
                    alert2.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    self.present(alert2, animated: true, completion: nil)
                }
            }
        }
        alert.addAction(OkBtu)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //firebase func
    func getData(_ userId: String) {
        db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                switch  documentSnapshot?.get("type") as? String {
                case "school":
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarS")
                    self.present(vc!, animated: true, completion: nil)
                case "event":
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarE")
                    self.present(vc!, animated: true, completion: nil)
                default:
                    print("Error: Couldn't find type for user \(userId)")
                }
            }
        }
    }
}

