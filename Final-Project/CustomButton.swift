//
//  CustomButton.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 14/01/2022.
//

import Foundation
import UIKit

extension UIButton {
    func applyCornerRadius() {
        layer.cornerRadius = layer.frame.height/2
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.gray.cgColor
    }
}
