//
//  CustomView.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 12/01/2022.
//


import UIKit

extension UIView {
    func applyShadow(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.15
        layer.shadowColor = UIColor.black.cgColor
    }
    
    
    func addTopView(titleLbl: String) {
        let topView = UIView()
        topView.frame = CGRect(x: 0, y: -20, width: self.bounds.width, height: 200)
        topView.backgroundColor = UIColor(#colorLiteral(red: 0.2493973076, green: 0.7426506877, blue: 0.7891102433, alpha: 1))
           topView.layer.cornerRadius = 40
           topView.layer.masksToBounds = false
           topView.layer.shadowOffset = CGSize(width: 0, height: 0.4)
           topView.layer.shadowRadius = 2
           topView.layer.shadowOpacity = 0.8
           topView.layer.shadowColor = UIColor.gray.cgColor
           self.addSubview(topView)
           
           let titleLable = UILabel(frame: CGRect(x: topView.bounds.maxX-80, y: topView.bounds.midY, width: 300, height: 50))
           titleLable.backgroundColor = .clear
           titleLable.text = titleLbl
        titleLable.font = UIFont(name: "System", size: 30)
           titleLable.textColor = UIColor(#colorLiteral(red: 0.1562460065, green: 0.1663181186, blue: 0.3201033175, alpha: 1))
        topView.addSubview(titleLable)
    }
}
