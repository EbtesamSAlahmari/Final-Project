//
//  EventDetailsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var eventOrganizerLbl: UILabel!
    @IBOutlet weak var eventDescriptionLbl: UITextView!
    @IBOutlet weak var eventEmailLbl: UILabel!
    @IBOutlet weak var eventCityLbl: UILabel!
    @IBOutlet weak var eventKindLbl: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    
    var selectedEvent:Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(".......\((selectedEvent?.eventID)!)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nameLbl.text = selectedEvent?.eventName
        self.eventOrganizerLbl.text = selectedEvent?.eventOrganizer
        self.eventDescriptionLbl.text = selectedEvent?.eventDescription
        self.eventEmailLbl.text = selectedEvent?.eventEmail
        self.eventCityLbl.text = selectedEvent?.eventCity
        self.eventKindLbl.text = selectedEvent?.eventKind
    }
    
    @IBAction func requestPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSendRequest", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendRequest" {
            let nextVc = segue.destination as! SendRequestVC
            nextVc.selectedEvent = selectedEvent
        }
    }
}

