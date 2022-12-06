//
//  MapController.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 06.12.2022.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController {
    
    let myMapView = MapView()
    
    override func viewDidLoad() {
        setup()
        layout()
    }
    
    
    func setup() {
        
        addChild(myMapView)
        view.addSubview(myMapView.view)
        myMapView.didMove(toParent: self)
        
        setupTapGesture()
        
        myMapView.segmententedControl.addTarget(self, action: #selector(segmentChosen), for: .primaryActionTriggered)
         
        setupBarButtonItem()
       
        
        
    }
    
    func setupBarButtonItem() {
        let organizerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showTableView))
        navigationItem.rightBarButtonItem = organizerBarButtonItem
    }
    
    @objc func showTableView() {
        myMapView.tableView.isHidden = !myMapView.tableView.isHidden
        

    }
    
    @objc func segmentChosen(_ sender: UISegmentedControl) {
        switch myMapView.segmententedControl.selectedSegmentIndex {
        case 0: myMapView.mapView.mapType = MKMapType.standard
        case 1: myMapView.mapView.mapType = MKMapType.satellite
        case 2: myMapView.mapView.mapType = MKMapType.hybrid
        default:
            print("Something went wrong")
        }
    }
    
    func layout() {
        
    }
    
    func setupTapGesture() {
        let longPressTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        myMapView.mapView.addGestureRecognizer(longPressTapGesture)
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        
        let location = gestureReconizer.location(in: myMapView.mapView)
        let coordinate = myMapView.mapView.convert(location, toCoordinateFrom: myMapView.mapView)
        
        showAlertController { [weak self] isAdded in
            if isAdded {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = self!.myMapView.pinTitle
                annotation.subtitle = self!.myMapView.pinSubtitle
                self!.myMapView.mapView.addAnnotation(annotation)
                self!.title = self!.myMapView.pinTitle
                
                self!.myMapView.tableView.reloadData()
            }
        }
    }
    
    func showAlertController(completion:@escaping (_ isAdded: Bool)->Void){
  
        let alertController = UIAlertController(title: "Add place", message: "Fill the all fields", preferredStyle: .alert)
        var isAdded = false
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            isAdded = true
            self!.myMapView.pinTitle = alertController.textFields![0].text ?? ""
            self!.myMapView.pinSubtitle = alertController.textFields![1].text ?? ""
            completion(isAdded)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            isAdded = false
            completion(isAdded)
        }
//
        alertController.addTextField {titleTextField in
            titleTextField.placeholder = "Enter the title"
        }

        alertController.addTextField {subTitleTextField in
            subTitleTextField.placeholder = "Enter the subtitle"
        }
//
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)

    }
    
}
