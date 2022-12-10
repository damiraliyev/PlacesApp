//
//  PlaceInfoView.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 08.12.2022.
//

import Foundation
import UIKit


protocol InfoDoneDelegate: AnyObject {
    func donePressed(title: String, subtitle: String, index: Int)
}

class PlaceInfoView: UIViewController {
    
    let placeTitleField = UITextField()
    let placeSubtitleField = UITextField()
    
    var indexOfAnnotation = 0
    
    var initialTitle = ""
    var initialSubtitle = ""
 
    weak var infoDoneDelegate: InfoDoneDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
        
        setup()
        layout()
    }
    
    
    func setup() {
        
        title = "Edit"
        placeTitleField.translatesAutoresizingMaskIntoConstraints = false
        placeTitleField.backgroundColor = .white
        placeTitleField.layer.cornerRadius = 5
        
        placeSubtitleField.translatesAutoresizingMaskIntoConstraints = false
        placeSubtitleField.backgroundColor = .white
        placeSubtitleField.layer.cornerRadius = 5
        
        setupNavBar()
        
        initialTitle = placeTitleField.text ?? "Unnamed"
        initialSubtitle = placeSubtitleField.text ?? ""
    }
    
    func setupNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    }
    
    @objc func doneButtonPressed() {
        if placeTitleField.text == "" {
            placeTitleField.text = initialTitle
        }
        
        infoDoneDelegate?.donePressed(title: placeTitleField.text!, subtitle: placeSubtitleField.text ?? "", index: indexOfAnnotation)
        navigationController?.popViewController(animated: true)
    }
    
    func layout() {
        view.addSubview(placeTitleField)
        view.addSubview(placeSubtitleField)
        
        NSLayoutConstraint.activate([
            placeTitleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            placeTitleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            placeTitleField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -64),
            placeTitleField.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            placeSubtitleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 64),
            placeSubtitleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -64),
            placeSubtitleField.topAnchor.constraint(equalTo: placeTitleField.bottomAnchor, constant: 24),
            placeSubtitleField.heightAnchor.constraint(equalToConstant: 25)
        ])
        
    }
}
