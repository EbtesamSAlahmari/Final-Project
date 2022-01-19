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
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
}

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

extension UITextField{
  func setLeftImage(imageName:String) {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    imageView.image = UIImage(systemName: imageName)
      imageView.tintColor = UIColor(#colorLiteral(red: 0.9688981175, green: 0.8095123768, blue: 0.3056389093, alpha: 1))
    self.leftView = imageView;
    self.leftViewMode = .always
      
      let underLineView = UIView()
      underLineView.translatesAutoresizingMaskIntoConstraints = false
      underLineView.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
      addSubview(underLineView)
      NSLayoutConstraint.activate([
          underLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
          underLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
          underLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3),
          underLineView.heightAnchor.constraint(equalToConstant: 1 )
      ])
  }
}

//extension UITextView {
//func textViewDidChange(_ textView: UITextView) {
//    let size = CGSize(width: superview.frame.width, height: .infinity)
//    let estimatedSize = self.sizeThatFits(size)
//    self.constraints.forEach { constraint in
//        if constraint.firstAttribute == .height {
//            constraint.constant = estimatedSize.height
//        }
//    }
//}
//}

