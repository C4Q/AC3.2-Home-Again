//
//  Utilities.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation
import UIKit

// Titles
protocol CellTitled {
    var titleForCell: String { get }
}

// Colors
struct ColorPalette {
    static let darkestBlue: UIColor = UIColor(red: 22/255, green: 87/255, blue: 109/255, alpha:1.0)
    static let darkBlue: UIColor = UIColor(red: 58/255, green: 153/255, blue: 181/255, alpha:1.0)
    static let midBlue: UIColor = UIColor(red: 101/255, green: 179/255, blue: 190/255, alpha:1.0)
    static let lightBlue: UIColor = UIColor(red: 142/255, green: 207/255, blue: 201/255, alpha:1.0)
    static let lightestBlue: UIColor = UIColor(red: 203/255, green: 233/255, blue: 244/255, alpha:1.0)
    static let textIconColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
    //    static let secondaryTextColor: UIColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
    //    static let dividerColor: UIColor = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
}

// Categories
public enum Resource: String {
    case shelter = "Drop-In Shelters"
    case foodstamp = "Food Stamp Centers"
    case jobs = "Job Centers"
    case library = "Libraries"
    case undeclared = ""
    
    static let sections: [String] = [Resource.shelter,
                                     Resource.foodstamp,
                                     Resource.jobs,
                                     Resource.library].map { $0.rawValue }
    
    static func numberOfResourceSections() -> Int {
        return Resource.sections.count
    }
    
    static func getEndPoint(_ resource: Resource.RawValue) -> String {
        switch resource {
        case "Drop-In Shelters":
            return "https://data.cityofnewyork.us/resource/kjtk-8yxq.json"
        case "Food Stamp Centers":
            return "https://data.cityofnewyork.us/resource/ma86-m5w3.json"
        case "Job Centers":
            return "https://data.cityofnewyork.us/resource/9ri9-nbz5.json"
        default:
            return ""
        }
    }
    
    static let boroughs: [String] = ["Brooklyn",
                                     "Bronx",
                                     "Manhattan",
                                     "Queens",
                                     "Staten Island"]
    
}
