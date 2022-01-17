//
//  RequestCell.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 03/01/2022.
//

import UIKit

class RequestCell: UITableViewCell {

    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var eventTeamLbl: UILabel!
    @IBOutlet weak var eventStatusLbl: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyShadow(cornerRadius: 20)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
