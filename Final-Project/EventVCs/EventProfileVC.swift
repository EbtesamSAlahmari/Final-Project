//
//  EventProfileVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 02/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import ProgressHUD

class EventProfileVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var eventOrganizerTxt: UITextField!
    @IBOutlet weak var eventDescriptionTxt: UITextView!
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityTxt: UITextField!
    @IBOutlet weak var eventPriceTxt: UITextField!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    let imagePicker = UIImagePickerController()
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var imageName = "\(UUID().uuidString).png"
    var imageStr = ""
    var editStatus = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        eventDescriptionTxt.delegate = self
        eventDescriptionTxt.isScrollEnabled = false
        settingBtn.applyCornerRadius()
        editBtn.applyCornerRadius()
        contentView.applyShadow(cornerRadius: 20)
        
        //ProgressHUD
        ProgressHUD.colorHUD = .darkGray
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.colorHUD = UIColor.clear
        ProgressHUD.show("", interaction: false)
        getEventData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
            updateView(state: false, hidden: true, color: .clear)
        } else {
            updateView(state: false, hidden: true, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)))
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.traitCollection.userInterfaceStyle == .dark {
            updateView(state: false, hidden: true, color: .clear)
        } else {
            updateView(state: false, hidden: true, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)))
        }
    }
    
    @IBAction func settingPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        if editStatus {
            if self.traitCollection.userInterfaceStyle == .dark {
                updateView(state: true, hidden: false, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)))
            } else {
                updateView(state: true, hidden: false, color: .white)
            }
            editStatus = false
        }else{
            if self.traitCollection.userInterfaceStyle == .dark {
                updateView(state: false, hidden: true, color: .clear)
            } else {
                updateView(state: false, hidden: true, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)))
            }
            editStatus = true
        }
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateEventData()
        if self.traitCollection.userInterfaceStyle == .dark {
            updateView(state: false, hidden: true, color: .clear)
        } else {
            updateView(state: false, hidden: true, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 0.5)))
        }
        
    }
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            sender.numberOfTapsRequired = 1
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
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
        
        state ? editBtn.setImage(UIImage(systemName: "checkmark.square"), for: .normal) :
        editBtn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
    }
    
    
    //MARK: - firebase function
    func getEventData() {
        if eventImage.image != UIImage(systemName: "photo") {
            uploadImage()
        }
        
        let img = eventImage.image == UIImage(systemName: "photo") ? "nil" : imageName
        
        if let userId = userId {
            db.collection("Users").document(userId).getDocument{ documentSnapshot, error in
                if let error = error {
                    print("Error: ",error.localizedDescription)
                }else {
                    self.nameTxt.text = documentSnapshot?.get("eventName") as? String ?? "???????????? ...."
                    self.eventOrganizerTxt.text = documentSnapshot?.get("eventOrganizer") as? String ?? "???? ????????"
                    self.eventDescriptionTxt.text = documentSnapshot?.get("eventDescription") as? String ?? "?????????? ????????????"
                    self.eventEmailLbl.text = documentSnapshot?.get("eventEmail") as? String
                    self.eventCityTxt.text = documentSnapshot?.get("eventCity") as? String ?? "???? ????????"
                    self.eventPriceTxt.text = String(documentSnapshot?.get("eventPrice") as? Double ?? 0.0)
                    let imgStr = documentSnapshot?.get("eventImage") as? String
                    if imgStr == "nil" {
                        self.eventImage.image = UIImage(systemName: "photo")
                        ProgressHUD.dismiss()
                    }
                    else {
                        self.loadImage(imgStr: imgStr ?? "nil" )
                        self.imageStr = imgStr ?? "nil"
                    }
                }
            }
        }
    }
    
    func updateEventData() {
        if let userId = userId {
            db.collection("Users").document(userId).updateData([
                "eventName" : self.nameTxt.text ?? "???????????? ...." ,
                "eventOrganizer" : self.eventOrganizerTxt.text ?? "????????????" ,
                "eventDescription": self.eventDescriptionTxt.text ?? "?????????? ????????????" ,
                "eventCity" : self.eventCityTxt.text ?? "???? ????????" ,
                "eventPrice" : Double(self.eventPriceTxt.text?.arToEnDigits() ?? "") ?? 0.0 ,
                
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
    
    
    
    func loadImage(imgStr: String) {
        let url = "gs://final-project-e67fe.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("=======================")
                print("Error: Image could not download!")
                print(error.localizedDescription)
                ProgressHUD.dismiss()
            } else {
                self.eventImage.image = UIImage(data: data!)
                ProgressHUD.dismiss()
            }
        }
    }
    //MARK: update event image
    func updateEventImage() {
        if eventImage.image != UIImage(systemName: "photo") {
            uploadImage()
        }
        
        self.db.collection("Users")
            .document(userId!).updateData(
                [
                    "eventImage": eventImage.image == UIImage(systemName: "photo") ? "nil" : imageName
                ])
        {(error) in
            if error == nil {
                print("Added image Succ..")
            }else {
                print(error!.localizedDescription)
            }
        }
    }
    
    
    func uploadImage()  {
        let imagefolder = Storage.storage().reference().child("images")
        if let imageData = eventImage.image?.jpegData(compressionQuality: 0.1) {
            imagefolder.child(imageName).putData(imageData, metadata: nil){
                (metaData , err) in
                if let error = err {
                    print(error.localizedDescription)
                }else {
                    print("???? ?????? ???????????? ??????????")
                }
            }
        }
    }
}

//MARK: -UIImagePickerController
extension EventProfileVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        eventImage.image = pickedImage
        updateEventImage()
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: -UITextViewDelegate
extension EventProfileVC: UITextViewDelegate  {
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = eventDescriptionTxt.sizeThatFits(size)
        eventDescriptionTxt.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}



extension String {
    func arToEnDigits() -> String {
        let arabicNumbers = ["??": "0","??": "1","??": "2","??": "3","??": "4","??": "5","??": "6","??": "7","??": "8","??": "9","??": "."]
        var txt = self
        arabicNumbers.map { txt = txt.replacingOccurrences(of: $0, with: $1)}
        return txt
    }
}
