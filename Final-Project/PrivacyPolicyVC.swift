//
//  PrivacyPolicyVC.swift
//  Final-Project
//
//  Created by Ebtesam Alahmari on 11/01/2022.
//

import UIKit
import PDFKit

class PrivacyPolicyVC: UIViewController {
    
    @IBOutlet weak var closeButOutlet: UIButton!
    @IBOutlet weak var TitleLable: UILabel!
    
    let pdfView = PDFView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show PrivacyPolicy pdf
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            pdfView.topAnchor.constraint(equalTo: TitleLable.topAnchor, constant: 55),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor , constant: 0),
            pdfView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        // Fit content in PDFView.
        pdfView.autoScales = true
        guard let path = Bundle.main.url(forResource: "PrivacyPolicy", withExtension: "pdf") else { return }
        if let document = PDFDocument(url: path) {
            pdfView.document = document
        }
    }
    
    @IBAction func CloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
