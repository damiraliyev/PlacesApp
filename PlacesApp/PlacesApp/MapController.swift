//
//  MapController.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 06.12.2022.
//

import Foundation
import UIKit
import MapKit
import CoreData

class MapController: UIViewController {
    
    
    
    let myMapView = MapView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var pinTitle = ""
    var pinSubtitle = ""
    
    var long = CLLocationDegrees()
    var latt = CLLocationDegrees()
    
    let zooming = 1500
    
    var index = -1
    var isForwarding = true
    
    var annotations: [MKPointAnnotation] = []
    
    override func viewDidLoad() {
        setup()
        
        
        loadItems()
        
        for place in myMapView.places {
            let annotation = MKPointAnnotation()
            annotation.title = place.title
            annotation.subtitle = place.subtitle
            annotation.coordinate.latitude = place.latitude
            annotation.coordinate.longitude = place.longtitude
            myMapView.mapView.addAnnotation(annotation)
            annotations.append(annotation)
        }
        
       
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
       
        myMapView.tableRowDelegate = self
        myMapView.calloutDelegate = self
        
        
        
    }
    
    func setupBarButtonItem() {
        let organizerBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(showTableView))
        navigationItem.rightBarButtonItem = organizerBarButtonItem
    }
    
    @objc func showTableView() {
        myMapView.tableView.isHidden = !myMapView.tableView.isHidden
        
        noPlaceLabelRegulator()
       
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
            moveToAnnotation(direction: .forward)
        }
    }
    
    @objc func backPressed() {
        print("Index:", index)
        
        
        if myMapView.places.count != 0{
            moveToAnnotation(direction: .backward)
        }
    }
    
    func moveToAnnotation(direction: Direction?) {
        var span = myMapView.mapView.region.span
        
        span.latitudeDelta /= 500;
        span.longitudeDelta /= 500;
        
        myMapView.mapView.region.span=span;
        myMapView.mapView.setRegion(myMapView.mapView.region, animated: false)
        
        if direction == .forward {
            index = (index + 1) % myMapView.places.count
        } else if direction == .backward {
            index = (index - 1) %% myMapView.places.count
        }
        
        
        myMapView.mapView.setCenter(CLLocationCoordinate2D(latitude: myMapView.places[index].latitude, longitude: myMapView.places[index].longtitude), animated: false)
        title = myMapView.places[index].title
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
                self!.annotations.append(annotation)
               
                self!.long = annotation.coordinate.longitude
                self!.latt = annotation.coordinate.latitude
                
                let newPlace = Place(context: self!.context)
                newPlace.title = self!.pinTitle
                newPlace.subtitle = self!.pinSubtitle
                newPlace.longtitude = coordinate.longitude
                newPlace.latitude = coordinate.latitude
                
                self!.savePlaces()

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
            
            if self!.pinTitle == "" {
                self!.pinTitle = "Unnamed"
            }
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
    
    func savePlaces() {
        do {
            try context.save()
        } catch {
            print("Error while saving context \(error)")
        }
        
        myMapView.tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Place> = Place.fetchRequest()
        
        do {
            myMapView.places = try context.fetch(request)
        } catch {
            print("Error while loading context \(error)")
        }
    }
    
    func noPlaceLabelRegulator() {
        if myMapView.tableView.isHidden == false && myMapView.places.count == 0 {
            myMapView.noPlacesLabel.isHidden = false
        } else if myMapView.tableView.isHidden == true || myMapView.places.count != 0 {
            myMapView.noPlacesLabel.isHidden = true
        }
        
    }
    
}



extension MapController: TableRowDelegate {
    func rowPressed(index: Int) {
        self.index = index
        moveToAnnotation(direction: nil)
        myMapView.tableView.isHidden = true
    }
    
    func placeAnnotationRemoved(placeIndex: Int) {
        
        context.delete(myMapView.places[placeIndex])
        myMapView.places.remove(at: placeIndex)
        myMapView.mapView.removeAnnotation(annotations[placeIndex])
        
        savePlaces()
        
        self.annotations.remove(at: placeIndex)
        
        noPlaceLabelRegulator()
        print(myMapView.mapView.annotations.count)
    }
    
    
}

extension MapController: CalloutDelegate {
    func calloutPressed(annotationView: MKAnnotationView) {
//        print(myMapView.mapView.annotations.index)
        let placeInfoView = PlaceInfoView()
        placeInfoView.infoDoneDelegate = self
        self.navigationController?.pushViewController(placeInfoView, animated: true)
        
        placeInfoView.placeTitleField.text = annotationView.annotation?.title ?? ""
        placeInfoView.placeSubtitleField.text = annotationView.annotation?.subtitle ?? ""
        placeInfoView.indexOfAnnotation = Int(myMapView.places.firstIndex(where: {$0.latitude == annotationView.annotation?.coordinate.latitude && $0.longtitude == annotationView.annotation?.coordinate.longitude})!)
    }
}

extension MapController: InfoDoneDelegate {
    
    func donePressed(title: String, subtitle: String, index: Int) {
        myMapView.places[index].title = title
        myMapView.places[index].subtitle = subtitle
        myMapView.tableView.reloadData()
        self.annotations[index].title = title
        self.annotations[index].subtitle = subtitle
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
