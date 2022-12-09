//
//  PlaceInfoView.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 08.12.2022.
//

import Foundation
import UIKit

class PlaceInfoView: UIViewController {
    
    let placeTitleField = UITextField()
    let placeSubtitleField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1.0)
        
        setup()
        layout()
    }
    
    
    func setup() {
        placeTitleField.translatesAutoresizingMaskIntoConstraints = false
        placeTitleField.backgroundColor = .white
        placeTitleField.layer.cornerRadius = 5
        
        placeSubtitleField.translatesAutoresizingMaskIntoConstraints = false
        placeSubtitleField.backgroundColor = .white
        placeSubtitleField.layer.cornerRadius = 5
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
