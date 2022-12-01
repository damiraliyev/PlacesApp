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
    }
    
    func setupTapGesture() {
        let longPressTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(longPressTapGesture)
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        print("Pressed")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
//        annotation.ima
        mapView.addAnnotation(annotation)
        
    }
    
    
    func layout() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }


}

extension ViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//        
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
//        
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        } else {
//            annotationView?.annotation = annotation
//        }
////
////        annotationView?.image = UIImage(systemName: "mappin")
////        annotationView?.tintColor = .blue
//    
//        
//        return annotationView
//    }
}
