//
//  EventsCell.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit

class EventsCell: UITableViewCell {
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventTeamLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var eventImg: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        eventImg.applyShadow(cornerRadius: 20)
        eventImg.clipsToBounds = true
        contentView.applyShadow(cornerRadius: 20)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
