//
//  Model.swift
//  PlacesApp
//
//  Created by Damir Aliyev on 07.12.2022.
//

import Foundation
import UIKit
import MapKit


struct Place {
    let title: String
    let subtitle: String
    let longtitude: CLLocationDegrees
    let latitude: CLLocationDegrees
}


enum Direction {
    case forward
    case backward
}
