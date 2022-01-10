//
//  UpdatePasswordVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 07/01/2022.
//

import UIKit
import Firebase

class UpdatePasswordVC: UIViewController {

    
    @IBOutlet weak var appIcon: UIImageView!
    
    @IBOutlet weak var currentPasswordTxt: UITextField!
    
    @IBOutlet weak var NewPasswordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changePasswordPressed(_ sender: Any) {
        updatePassword()
        navigationController?.popViewController(animated: true)
    }
    

    func updatePassword() {
        let user = Auth.auth().currentUser
        let credential: AuthCredential
        credential = EmailAuthProvider.credential(withEmail: (user?.email)! , password: currentPasswordTxt.text!)
        user?.reauthenticate(with: credential , completion: { (authDataResult, error) in
            if let error = error {
                // An error happened.
                let resetFailedAlert = UIAlertController(title: "خطأ" , message: error.localizedDescription , preferredStyle: .alert)
                resetFailedAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                self.present(resetFailedAlert, animated: true, completion: nil)
            } else {
                // User re-authenticated.
                Auth.auth().currentUser?.updatePassword(to: self.NewPasswordTxt.text!, completion: { (error) in
                    if let error = error {
                        print(error)
                    }
                })
                let resetPasswordSuccess = UIAlertController(title: "كلمة المرور" , message: "تم تغيير كلمة المرور بنجاح", preferredStyle: .alert)
                resetPasswordSuccess.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(resetPasswordSuccess, animated: true, completion: nil)
            }
        })
    }
}
