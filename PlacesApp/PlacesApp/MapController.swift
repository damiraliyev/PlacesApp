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
    
    var pinTitle = ""
    var pinSubtitle = ""
    
    var long = CLLocationDegrees()
    var latt = CLLocationDegrees()
    
    let zooming = 1500
    
    var index = -1
    var isForwarding = true
    
    override func viewDidLoad() {
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(myMapView.backButton.frame.size.width)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(myMapView.backButton.bounds.size.width)
    }
    
    func setup() {
        
        addChild(myMapView)
        view.addSubview(myMapView.view)
        myMapView.didMove(toParent: self)
        
        setupTapGesture()
        
        myMapView.segmententedControl.addTarget(self, action: #selector(segmentChosen), for: .primaryActionTriggered)
         
        setupBarButtonItem()
        
        
        myMapView.forwardButton.addTarget(self, action: #selector(forwardPressed), for: .primaryActionTriggered)
        
        myMapView.backButton.addTarget(self, action: #selector(backPressed), for: .primaryActionTriggered)
       
        
        
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
    
    @objc func forwardPressed() {

        if myMapView.places.count != 0 {

            var span = myMapView.mapView.region.span
            
            span.latitudeDelta /= 500;
            span.longitudeDelta /= 500;
            
            myMapView.mapView.region.span=span;
            myMapView.mapView.setRegion(myMapView.mapView.region, animated: false)
            
            index = (index + 1) % myMapView.places.count
            myMapView.mapView.setCenter(CLLocationCoordinate2D(latitude: myMapView.places[index].latitude, longitude: myMapView.places[index].longtitude), animated: false)
            title = myMapView.places[index].title

        }
    }
    
    @objc func backPressed() {
        print("Index:", index)
        
        
        if myMapView.places.count != 0{

            var span = myMapView.mapView.region.span
            
            span.latitudeDelta /= 500;
            span.longitudeDelta /= 500;
            
            myMapView.mapView.region.span=span;
            myMapView.mapView.setRegion(myMapView.mapView.region, animated: false)
            
            
            index = (index - 1) %% myMapView.places.count
            print("MODULUS INDEX", index)
            myMapView.mapView.setCenter(CLLocationCoordinate2D(latitude: myMapView.places[index].latitude, longitude: myMapView.places[index].longtitude), animated: false)
            title = myMapView.places[index].title            
        }
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
                annotation.title = self!.pinTitle
                annotation.subtitle = self!.pinSubtitle
                self!.myMapView.mapView.addAnnotation(annotation)
               
                
                self!.long = annotation.coordinate.longitude
                self!.latt = annotation.coordinate.latitude
                
                self!.myMapView.tableView.reloadData()
                
                let newPlace = Place(title: self!.pinTitle, subtitle: self!.pinSubtitle, longtitude: coordinate.longitude, latitude: coordinate.latitude)
                
                self!.myMapView.places.append(newPlace)
                self!.myMapView.tableView.reloadData()
            }
        }
    }
    
    func showAlertController(completion:@escaping (_ isAdded: Bool)->Void){
  
        let alertController = UIAlertController(title: "Add place", message: "Fill the all fields", preferredStyle: .alert)
        var isAdded = false
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            isAdded = true
            self!.pinTitle = alertController.textFields![0].text ?? ""
            self!.pinSubtitle = alertController.textFields![1].text ?? ""
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


infix operator %%

extension Int {
    static  func %% (_ left: Int, _ right: Int) -> Int {
        if left >= 0 { return left % right }
        if left >= -right { return (left+right) }
        return ((left % right)+right)%right
    }
}
