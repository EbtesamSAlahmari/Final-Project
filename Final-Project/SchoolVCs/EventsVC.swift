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
    @IBOutlet weak var eventKindPicker: UIPickerView!
    @IBOutlet weak var eventCityPicker: UIPickerView!
    
    let db = Firestore.firestore()
    var userId = Auth.auth().currentUser?.uid
    var events = [Event]()
    var selectedEvent:Event?
   // var eventKindArray = ["الكل","ربحية","غير ربحية"]
    var cities = [
        "الكل",
        "الرياض",
                    "مكة المكرمة",
                    "المدينةالمنورة",
                    "القصيم",
                    "الشرقية",
                    "عسير",
                    "تبوك",
                    "حائل",
                    "الحدودالشمالية",
                    "جازان",
                    "نجران",
                    "الباحة",
                    "الجوف"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        eventKindPicker.delegate = self
        eventKindPicker.dataSource = self
        eventCityPicker.delegate = self
        eventCityPicker.dataSource = self
        searchBer.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        filterEventData(fieldName: "type", equalTo: "event")
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
                    let eventID = data["eventID"] as? String ?? "nil"
                    let eventName =  data["eventName"] as? String ?? "nil"
                    let eventOrganizer =  data["eventOrganizer"] as? String ?? "nil"
                    let eventDescription =  data["eventDescription"] as? String ?? "nil"
                    let eventEmail =  data["eventEmail"] as? String ?? "nil"
                    let eventCity =  data["eventCity"] as? String ?? "nil"
                    let eventPrice =  data["eventPrice"] as? Double ?? 0.0
                    let newEvent = Event(type: "event", eventID: eventID, eventName: eventName, eventOrganizer: eventOrganizer, eventDescription: eventDescription, eventEmail: eventEmail, eventCity: eventCity, eventPrice: eventPrice)
                    self.events.append(newEvent)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    if self.events.isEmpty {
                        self.tableView.setEmptyMessage("لايوجد فعاليات")
                    }
                }
            }
        }
    }
}

//MARK: -UITableView
extension EventsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventsCell") as! EventsCell
        cell.eventNameLbl.text = events[indexPath.row].eventName
        cell.eventTeamLbl.text = events[indexPath.row].eventOrganizer
        cell.cityLbl.text = events[indexPath.row].eventCity
        cell.priceLbl.text = "\(events[indexPath.row].eventPrice ?? 0)" + " ريال" 
        print("\(events[indexPath.row].eventPrice ?? 0)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
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
      //  if pickerView.tag == 0 {
            return cities.count
//        } else {
//            return eventKindArray.count
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       // if pickerView.tag == 0 {
            return cities[row]
//        } else {
//            return eventKindArray[row]
//        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            if cities[row] == "الكل" {
                //
            }else {
               // cities = cities.filter({$0 == cities[row] })
            }
        }
//        else {
//            if eventKindArray[row] == "الكل"{
//                filterEventData(fieldName: "type", equalTo: "event")
//            }else {
//                filterEventData(fieldName: "eventKind", equalTo: eventKindArray[row])
//                // events = events.filter { $0.eventKind == eventKindArray[row]}
//            }
//        }
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
