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
        settingBtn.applyCornerRadius()
        editBtn.applyCornerRadius()
        contentView.applyShadow(cornerRadius: 20)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
        self.tabBarController?.tabBar.isHidden = false
        getEventData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateView(state: false, hidden: true, color: .white)
    }
    
    @IBAction func settingPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as! SettingVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        if editStatus {
            updateView(state: true, hidden: false, color: UIColor(#colorLiteral(red: 0.955969274, green: 0.9609010816, blue: 0.96937114, alpha: 1)))
            editStatus = false
        }else{
            updateView(state: false, hidden: true, color: .white)
            editStatus = true
        }
       
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateEventData()
        updateView(state: false, hidden: true, color: .white)
    }
    
    @IBAction func tapGestureRecognizer(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            sender.numberOfTapsRequired = 1
            print("-------------===============")
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
                    self.nameTxt.text = documentSnapshot?.get("eventName") as? String ?? "فعالية ...."
                    self.eventOrganizerTxt.text = documentSnapshot?.get("eventOrganizer") as? String ?? "لم يحدد"
                    self.eventDescriptionTxt.text = documentSnapshot?.get("eventDescription") as? String ?? "الوصف لايوجد"
                    self.eventEmailLbl.text = documentSnapshot?.get("eventEmail") as? String
                    self.eventCityTxt.text = documentSnapshot?.get("eventCity") as? String ?? "لم يحدد"
                    self.eventPriceTxt.text = String(documentSnapshot?.get("eventPrice") as? Double ?? 0.0)
                    let imgStr = documentSnapshot?.get("eventImage") as? String
                    if imgStr == "nil" {
                        self.eventImage.image = UIImage(systemName: "photo")
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
                "eventName" : self.nameTxt.text ?? "فعالية ...." ,
                "eventOrganizer" : self.eventOrganizerTxt.text ?? "لايوجد" ,
                "eventDescription": self.eventDescriptionTxt.text ?? "الوصف لايوجد" ,
                "eventCity" : self.eventCityTxt.text ?? "لم يحدد" ,
                "eventPrice" : Double(self.eventPriceTxt.text ?? "") ?? 0.0 ,

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
            if error != nil {
                print("Error: Image could not download!")
                print("===================")
                print(error?.localizedDescription)
                
            } else {
                self.eventImage.image = UIImage(data: data!)
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
                    print("تم رفع الصورة بنجاح")
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
