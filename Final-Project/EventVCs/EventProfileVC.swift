//
//  EventProfileVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class EventProfileVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var eventOrganizerTxt: UITextField!
    @IBOutlet weak var eventDescriptionTxt: UITextView!
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityTxt: UITextField!
    
    @IBOutlet weak var eventPriceTxt: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getEventData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: #colorLiteral(red: 0.9669799209, green: 0.9765892625, blue: 0.9980371594, alpha: 1))
    }
    
    @IBAction func settingPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        updateView(state: true, hidden: false, color: .white)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        updateEventData()
        updateView(state: false, hidden: true, color: #colorLiteral(red: 0.9669799209, green: 0.9765892625, blue: 0.9980371594, alpha: 1))
    }
    
//    func changeStatusBtn(_ button: UIButton) {
//        if button.currentImage == UIImage(systemName: "squareshape") {
//            button.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
//            
//        }else {
//            button.setImage(UIImage(systemName: "squareshape"), for: .normal)
//        }
//    }
    
    func updateView(state: Bool, hidden: Bool, color: UIColor) {
        nameTxt.isUserInteractionEnabled = state
        eventOrganizerTxt.isUserInteractionEnabled = state
        eventDescriptionTxt.isUserInteractionEnabled = state
        eventCityTxt.isUserInteractionEnabled = state
        eventPriceTxt.isUserInteractionEnabled = state
        saveBtn.isHidden = hidden
        
        nameTxt.backgroundColor = color
        eventOrganizerTxt.backgroundColor = color
        eventDescriptionTxt.backgroundColor = color
        eventCityTxt.backgroundColor = color
        eventPriceTxt.backgroundColor = color
    }
    
    
    
    //MARK: - firebase function
    func getEventData() {
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameTxt.text = documentSnapshot?.get("eventName") as? String ?? "فعالية ...."
                    self.eventOrganizerTxt.text = documentSnapshot?.get("eventOrganizer") as? String ?? "لم يحدد"
                    self.eventDescriptionTxt.text = documentSnapshot?.get("eventDescription") as? String ?? "الوصف لايوجد"
                    self.eventEmailLbl.text = documentSnapshot?.get("eventEmail") as? String
                    self.eventCityTxt.text = documentSnapshot?.get("eventCity") as? String ?? "لم يحدد"
                    self.eventPriceTxt.text = String(documentSnapshot?.get("eventPrice") as? Double ?? 0.0)
                }
            }
        }
    }
    
    func updateEventData() {
        if let userId = userId {
            db.collection("Users").document(userId).updateData([
                "eventName" : self.nameTxt.text ?? "فعالية ...." ,
                "eventOrganizer" : self.eventOrganizerTxt.text ?? "لايوجد" ,
                "eventDescription": self.eventDescriptionTxt.text ?? "الوصف لايوجد" ,
                "eventCity" : self.eventCityTxt.text ?? "لم يحدد" ,
                "eventPrice" : Double(self.eventPriceTxt.text ?? "") ?? 0.0
            ])
            {(error) in
                if error == nil {
                    print("update event info  Succ..")
                }else {
                    print(error!.localizedDescription)
                }
            }
        }
    }
}

//extension EventProfileVC: UIPickerViewDelegate, UIPickerViewDataSource  {
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        pickerData.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerData[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        eventKind = pickerData[row]
//    }
//
//
//}
