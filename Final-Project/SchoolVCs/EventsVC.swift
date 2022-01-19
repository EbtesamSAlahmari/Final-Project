//
//  EventsVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 01/01/2022.
//

import UIKit
import Firebase
import FirebaseFirestore

class EventsVC: UIViewController {
    
    @IBOutlet var searchBer: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventCityPicker: UIPickerView!
    @IBOutlet weak var topView: UIView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var events = [Event]()
    var alterEvents = [Event]()
    var selectedEvent:Event?
 
    var cities = [
        "الكل",
        "الرياض",
        "مكة المكرمة",
        "المدينة المنورة",
        "جدة",
        "القصيم",
        "الشرقية",
        "ابها",
        "تبوك",
        "حائل",
        "جازان",
        "نجران",
        "الباحة",
        "الجوف",
        "الاحساء",
        "حفر الباطن",
        
 ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        eventCityPicker.delegate = self
        eventCityPicker.dataSource = self
        searchBer.delegate = self
        topView.applyShadow(cornerRadius: 40)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.filterEventData(fieldName: "type", equalTo: "event")
      
    }
    
    
    
    //MARK: - get specific documents from a collection
    func filterEventData(fieldName: String, equalTo: String ) {
        db.collection("Users").whereField(fieldName, isEqualTo: equalTo).getDocuments {
            querySnapshot, error in
            self.events = []
            if let error = error {
                print("Error: ",error.localizedDescription)
            }else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let eventID = data["eventID"] as? String ?? "لايوجد"
                    let eventName =  data["eventName"] as? String ?? "لم يحدد"
                    let eventOrganizer =  data["eventOrganizer"] as? String ?? "لم يحدد"
                    let eventDescription =  data["eventDescription"] as? String ?? "لايوجد"
                    let eventEmail =  data["eventEmail"] as? String ?? "nil"
                    let eventCity =  data["eventCity"] as? String ?? "لم يحدد"
                    let eventImage =  data["eventImage"] as? String ?? "nil"
                    let eventPrice =  data["eventPrice"] as? Double ?? 0.0
                    let newEvent = Event(type: "event", eventID: eventID, eventName: eventName, eventOrganizer: eventOrganizer, eventDescription: eventDescription, eventEmail: eventEmail, eventCity: eventCity, eventImage:eventImage, eventPrice: eventPrice)
                    self.events.append(newEvent)
                    self.alterEvents = self.events
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK: -UITableView
extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        var numOfSections: Int = 0
        if !events.isEmpty
        {
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            self.tableView.setEmptyMessage("لايوجد فعاليات")
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell") as! EventsCell
        cell.eventNameLbl.text = events[indexPath.row].eventName
        cell.eventTeamLbl.text = events[indexPath.row].eventOrganizer
        cell.cityLbl.text = events[indexPath.row].eventCity
        cell.priceLbl.text = "\(events[indexPath.row].eventPrice ?? 0)" + " ريال"
        
        let imgStr = events[indexPath.row].eventImage ?? "nil"
        let url = "gs://final-project-e67fe.appspot.com/images/" + "\(imgStr)"
        let Ref = Storage.storage().reference(forURL: url)
        Ref.getData(maxSize: 1 * 1024 * 1024) { dataImg, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
                cell.eventImg.image = UIImage(data:dataImg!)
            }
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        385
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEvent = events[indexPath.row]
        performSegue(withIdentifier: "moreEventDetails", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreEventDetails" {
            let nextVc = segue.destination as! EventDetailsVC
            nextVc.selectedEvent = selectedEvent
        }
    }
    
    
}

//MARK: -UIPickerView
extension EventsVC: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return cities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       events = alterEvents
            if cities[row] == "الكل" {
               filterEventData(fieldName: "type", equalTo: "event")
            }else  {
                events = events.filter({$0.eventCity == cities[row] })
            }
        tableView.reloadData()
    }
    
}

//MARK: -UISearchBarDelegate
extension EventsVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            filterEventData(fieldName: "type", equalTo: "event")
        }else {
            events = events.filter{$0.eventName.contains(searchBar.text!)}
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterEventData(fieldName: "type", equalTo: "event")
    }
}
