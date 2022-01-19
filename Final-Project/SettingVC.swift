//
//  SettingVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import MessageUI

class SettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var  Emailtxt = UITextField()
    var  CurrentPasswordtxt = UITextField()
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var type = ""
    
    let settingArray = [["عن التطبيق","info.circle"],["راسلنا","envelope"],["مشاركة التطبيق","square.and.arrow.up"],["سياسة الخصوصية","lock.shield"],["تغيير كلمة المرور","lock.open"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "هل انت متأكد من تسجيل الخروج؟", preferredStyle: .alert)
        let signOutBtn = UIAlertAction(title: "تسجيل خروج", style: .destructive) { alertAction in
            self.signOut()
        }
        alert.addAction(signOutBtn)
        alert.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountPressed(_ sender: Any) {
        delete()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! SignInVC
            self.present(vc, animated: true, completion: nil)
        }catch {
            print("Error: ",error.localizedDescription)
        }
    }
    
    
    func delete() {
        //let userID = Auth.auth().currentUser?.email
        let alertController = UIAlertController(title: "حذف الحساب" , message: "هل انت متأكد من حذف الحساب ؟" , preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (emailTextField) in
            self.Emailtxt = emailTextField
            emailTextField.placeholder = "البريد الالكتروني"
            emailTextField.text = "1@1.com"
        }
        alertController.addTextField { (passwordTextField) in
            self.CurrentPasswordtxt = passwordTextField
            passwordTextField.placeholder = "كلمة المرور"
            passwordTextField.isSecureTextEntry = true
            passwordTextField.text = "1234567"
        }
        let cancelAction = UIAlertAction(title: "إلغاء" , style: UIAlertAction.Style.default, handler: nil)
        let deleteAction = UIAlertAction(title: "حذف" , style: UIAlertAction.Style.destructive) { (action) in
            
            let user = Auth.auth().currentUser
            let credential: AuthCredential
            credential = EmailAuthProvider.credential(withEmail: self.Emailtxt.text! , password: self.CurrentPasswordtxt.text!)
            
            user?.reauthenticate(with: credential, completion: { (authResult, error) in
                if let error = error {
                    // An error happened.
                    let FailedAlert = UIAlertController(title: "خطا" , message: error.localizedDescription , preferredStyle: .alert)
                    FailedAlert.addAction(UIAlertAction(title: "حسنا", style: .default, handler: nil))
                    self.present(FailedAlert, animated: true, completion: nil)
                    
                }else{
                    
                    self.db.collection("Users").getDocuments { querySnapshot, error in
                        if let error = error {
                            print("Error: ",error.localizedDescription)
                        }else {
                            for document in querySnapshot!.documents {
                                let userData = document.data()
                                let type = userData["type"] as? String ?? "nil"
                                if type == "school" {
                                    self.deleteRequest(field: "schoolID", equalTo: self.userId! )
                                    print("ssssssssssss")
                                }
                                if type == "event" {
                                    print("eeeeeeeeeee")
                                    //                                    self.deleteRequest(field: "eventID", equalTo: self.userId! )
                                    //
                                    if let userId = self.userId {
                                        self.db.collection("Users").whereField("eventID", isEqualTo: self.userId!).getDocuments { querySnapshot, error in
                                            if let error = error {
                                                print("Error: ",error.localizedDescription)
                                            }else {
                                                for document in querySnapshot!.documents {
                                                    let userData = document.data()
                                                    let img = userData["eventImage"] as? String ?? "nil"
                                                    print("iiiiiiiiiii",img)
                                                    let url = "gs://final-project-e67fe.appspot.com/images/" + "\(img)"
                                                    let imageRef = Storage.storage().reference(forURL: url)
                                                    imageRef.delete { error in
                                                        if let error = error {
                                                            print("--------------",error.localizedDescription)
                                                        } else {
                                                            print("image deleted successfully")
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    //
                                }
                            }
                        }
                    }
                    
                    // Delete the user
                    self.db.collection("Users").document(self.userId!).delete()
                    print("Document user successfully removed!")
                    
                    // 4-Delete user account
                    user?.delete()
                    print("Account deleted.")
                    // 5-back to rootViewController
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC") as! SignInVC
                    self.present(vc, animated: true, completion: nil)
                    
                }
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteRequest(field: String, equalTo: String ) {
        self.db.collection("Requests").whereField(field, isEqualTo:  equalTo ).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let requestID = data["requestID"] as? String ?? "nil"
                    self.db.collection("Requests").document(requestID).delete()
                    print("Document request successfully removed!")
                }
            }
        }
    }
    
    
}
//MARK: -UITableView
extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SettingCell
        cell.nameLbl.text = settingArray[indexPath.row].first
        cell.icon.image = UIImage(systemName: settingArray[indexPath.row].last ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row
        {
        case 0:
            performSegue(withIdentifier: "aboutUs", sender: nil)
        case 1:
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            sendEmail()
        case 2:
            let firstActivityItem = "يهدف التطبيق الى تدوين مراحل التطور لطفلك في كل مرحلة عمرية وذلك لتوثيق ومتابعة تطوره و ذلك عن طريق اضافة وزنه وطولة و ما اتقنه من مهارة و التقاط صورة له في تلك المرحلة العمرية وذلك ايضا لتدوين الذكريات الجميله . ايضا يفيدك في معرفة ما اذا كان هناك مشكلة لدى طفلك ويحتاج التدخل المبكر "
            let secondActivityItem : NSURL = NSURL(string: "itms-apps://itunes.apple.com/app/bars/id1456324528")! // تغيير رقم ID
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVC") as! PrivacyPolicyVC
            self.present(vc, animated: true, completion: nil)
        case 4:
            performSegue(withIdentifier: "changePassword", sender: nil)
        default:
            print("nothing")
        }
    }
    
}

//MARK: -MFMailComposeViewControllerDelegate
extension SettingVC: MFMailComposeViewControllerDelegate {
    func sendEmail(){
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["example@example.com"])
        composeVC.setSubject("subject")
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController,didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
