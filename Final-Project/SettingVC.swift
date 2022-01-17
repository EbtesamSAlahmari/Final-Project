//
//  SettingVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import MessageUI

class SettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
