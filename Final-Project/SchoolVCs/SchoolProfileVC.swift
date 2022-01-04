//
//  SchoolProfileVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class SchoolProfileVC: UIViewController {
   
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var requests = [Request]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getSchoolData()
    }
    
    //MARK: - firebase function
    func getSchoolData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameLbl.text = documentSnapshot?.get("schoolName") as? String
                    self.descriptionLbl.text = documentSnapshot?.get("schoolDescription") as? String
                    self.locationLbl.text = documentSnapshot?.get("schoolLocation") as? String
                    
                    
                    
                    
                }
            }
        }
    }
    
    
}


//MARK: -UITableView
extension SchoolProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell") as! RequestCell
        cell.eventNameLbl.text = requests[indexPath.row].eventName
        cell.eventTeamLbl.text = requests[indexPath.row].eventOrganizer
        cell.eventStatusLbl.text = requests[indexPath.row].requestStatus
        return cell
    }
    
}
