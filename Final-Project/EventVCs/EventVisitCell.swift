//
//  EventVisitCell.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 06/01/2022.
//

import UIKit

class EventVisitCell: UITableViewCell {
    @IBOutlet weak var schoolName: UILabel!
    @IBOutlet weak var visitDate: UILabel!
    @IBOutlet weak var visitPrice: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.applyShadow(cornerRadius: 20)
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
