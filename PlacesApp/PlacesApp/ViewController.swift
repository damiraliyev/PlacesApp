//
//  ViewController.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 01.12.2022.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
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
    
    let coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        layout()
    }
    
    
    func setup() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        setupTapGesture()
    
        setupContainerView()
        
        setupSegments()
        
    }
    
    func setupTapGesture() {
        let longPressTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(longPressTapGesture)
    }
    
    func setupContainerView() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(blurEffectView)
    }
    
    func setupSegments() {
        segmententedControl.translatesAutoresizingMaskIntoConstraints = false
        segmententedControl.insertSegment(withTitle: "Standard", at: 0, animated: true)
        segmententedControl.insertSegment(withTitle: "Sattelite", at: 1, animated: true)
        segmententedControl.insertSegment(withTitle: "Hybrid", at: 2, animated: true)
        segmententedControl.backgroundColor = .white
        segmententedControl.selectedSegmentIndex = 0
        
        segmententedControl.addTarget(self, action: #selector(segmentChosen), for: .primaryActionTriggered)
    }
    
    @objc func segmentChosen(_ sender: UISegmentedControl) {
        switch segmententedControl.selectedSegmentIndex {
        case 0: mapView.mapType = MKMapType.standard
        case 1: mapView.mapType = MKMapType.satellite
        case 2: mapView.mapType = MKMapType.hybrid
        default:
            print("Something went wrong")
        }
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        
        print("Pressed")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Kyzylorda"
        annotation.subtitle = "Central square"
        mapView.addAnnotation(annotation)
        
        
        
    }
    
    
    func layout() {
        view.addSubview(mapView)
        view.addSubview(containerView)
        view.addSubview(segmententedControl)
        
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
        
       
    }


}

extension ViewController: MKMapViewDelegate {
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
}
