//
//  ViewController.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 01.12.2022.
//

import UIKit
import MapKit
import CoreData


protocol TableRowDelegate: AnyObject {
    func rowPressed(index: Int)
    
    func placeAnnotationRemoved(placeIndex: Int)
}

protocol CalloutDelegate: AnyObject {
    func calloutPressed(annotationView: MKAnnotationView)
}

class MapView: UIViewController {
    
    
    
    
    var places: [Place] = []
    
    let mapView: MKMapView = {
        let map = MKMapView()
        
        return map
    }()
    
    let segmententedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        return segmentedControl
    }()
    
    let containerView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let tableView = UITableView()
    
    weak var tableRowDelegate: TableRowDelegate?
    
    weak var calloutDelegate: CalloutDelegate?
    
    let blurEffect = UIBlurEffect(style: .light)
    
    var forwardButton = UIButton()
    var backButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        layout()
       
    }
    
    
    func setup() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
//        setupTapGesture()
        
        
        setupContainerView()
        
        setupSegments()
        
        setupTableView()
        
//        setupTapGesture()
     
        
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = tableView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
 
        tableView.backgroundColor = .clear
        tableView.backgroundView = blurEffectView
//
        
    }
    
//    func setupTapGesture() {
//        let longPressTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
//        mapView.addGestureRecognizer(longPressTapGesture)
//    }
//
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        setupBlurEffect(bluredView: containerView)
    }
    
    func setupBlurEffect(bluredView: UIView) {
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bluredView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bluredView.addSubview(blurEffectView)
    }
    
    func setupSegments() {
        segmententedControl.translatesAutoresizingMaskIntoConstraints = false
        segmententedControl.insertSegment(withTitle: "Standard", at: 0, animated: true)
        segmententedControl.insertSegment(withTitle: "Sattelite", at: 1, animated: true)
        segmententedControl.insertSegment(withTitle: "Hybrid", at: 2, animated: true)
        segmententedControl.backgroundColor = .white
        segmententedControl.selectedSegmentIndex = 0
        
//        segmententedControl.addTarget(self, action: #selector(segmentChosen), for: .primaryActionTriggered)
    }
    
//    @objc func segmentChosen(_ sender: UISegmentedControl) {
//        switch segmententedControl.selectedSegmentIndex {
//        case 0: mapView.mapType = MKMapType.standard
//        case 1: mapView.mapType = MKMapType.satellite
//        case 2: mapView.mapType = MKMapType.hybrid
//        default:
//            print("Something went wrong")
//        }
//    }
    
//    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
//        let location = gestureReconizer.location(in: mapView)
//        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
//        
//        showAlertController { [weak self] isAdded in
//            if isAdded {
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = coordinate
//                annotation.title = self!.pinTitle
//                annotation.subtitle = self!.pinSubtitle
//                self!.mapView.addAnnotation(annotation)
//                self!.title = self!.pinTitle
//            }
//        
//           
//
//        }
//        
//        
//       
//        
//    }
    
//    func showAlertController(completion:@escaping (_ isAdded: Bool)->Void){
//        let alertController = UIAlertController(title: "Add place", message: "Fill the all fields", preferredStyle: .alert)
//        var isAdded = false
//        
//        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
//            isAdded = true
//            self!.pinTitle = alertController.textFields![0].text ?? ""
//            self!.pinSubtitle = alertController.textFields![1].text ?? ""
//            completion(isAdded)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {_ in
//            isAdded = false
//            completion(isAdded)
//        }
//        
//        alertController.addTextField {titleTextField in
//            titleTextField.placeholder = "Enter the title"
//        }
//        
//        alertController.addTextField {subTitleTextField in
//            subTitleTextField.placeholder = "Enter the subtitle"
//        }
//        
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true)
//
//    }
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(containerView)
        view.addSubview(segmententedControl)
        view.addSubview(tableView)
        
        view.addSubview(forwardButton)
        view.addSubview(backButton)
        
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.size.width / 5)
        ])
        
        NSLayoutConstraint.activate([
            segmententedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            segmententedControl.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            
            forwardButton.leadingAnchor.constraint(equalTo: segmententedControl.trailingAnchor),
            forwardButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            forwardButton.centerYAnchor.constraint(equalTo: segmententedControl.centerYAnchor),
            forwardButton.heightAnchor.constraint(equalToConstant: 50)

        ])

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: segmententedControl.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: segmententedControl.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        

    }


}

extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        let detailButton = UIButton(type: .detailDisclosure)

        if annotationView == nil {

            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")

            annotationView?.animatesDrop = true
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = detailButton
          
        } else {

            annotationView?.annotation = annotation
        }
        
       
        return annotationView

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        calloutDelegate?.calloutPressed(annotationView: view)
        
    }
}


extension MapView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableRowDelegate?.rowPressed(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("INDEXPATH", indexPath.row)

            print("INDEXPATH", indexPath.row)
            tableView.reloadData()
            tableRowDelegate?.placeAnnotationRemoved(placeIndex: indexPath.row)
        }
    }
}


extension MapView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()

        content.text = places[indexPath.row].title
        content.secondaryText = places[indexPath.row].subtitle
        cell.contentConfiguration = content
        
        
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = cell.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
       
        cell.backgroundColor = .clear
        cell.backgroundView = blurEffectView
        
        return cell
    }
    
    
}
