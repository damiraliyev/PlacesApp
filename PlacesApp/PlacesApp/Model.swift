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
    var title: String
    var subtitle: String
    let longtitude: CLLocationDegrees
    let latitude: CLLocationDegrees
}


enum Direction {
    case forward
    case backward
}
