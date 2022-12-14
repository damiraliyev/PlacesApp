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
    
    let noPlacesLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        layout()
       
    }
    
    
    func setup() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        
        setupContainerView()
        
        setupSegments()
        
        setupTableView()

        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        noPlacesLabel.translatesAutoresizingMaskIntoConstraints = false
        noPlacesLabel.text = "No places"
        noPlacesLabel.isHidden = true

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
    }


    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(containerView)
        view.addSubview(segmententedControl)
        view.addSubview(tableView)
        view.addSubview(noPlacesLabel)
        view.addSubview(forwardButton)
        view.addSubview(backButton)
        
        
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noPlacesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            noPlacesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.size.width / 5)
        ])
        
        NSLayoutConstraint.activate([
            segmententedControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 64),
            segmententedControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -64),
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
            forwardButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 5)

        ])

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.trailingAnchor.constraint(equalTo: segmententedControl.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: segmententedControl.centerYAnchor),
            backButton.heightAnchor.constraint(equalToConstant: view.frame.size.width / 5)
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
