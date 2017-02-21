//
//  Library.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Library: ResourcesTable {
    let type = "library"
    let borocode: String
    let borough: String
    let houseNumber: String
    let facilityName: String
    let streetAddress: String
    let system: String
    let url: String
    let zipCode: String
    let latitude: Double
    let longitude: Double
    let facilityAddress: String
    
    init(borocode: String, city: String, houseNumber: String, name: String, facilityName: String, streetAddress: String, system: String, url: String, zip: String, latitude: Double, longitude: Double, facilityAddress: String) {
        self.borocode = borocode
        self.borough = city
        self.houseNumber = houseNumber
        self.facilityName = name
        self.streetAddress = streetAddress
        self.system = system
        self.url = url
        self.zipCode = zip
        self.latitude = latitude
        self.longitude = longitude
        self.facilityAddress = houseNumber + " " + streetAddress
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let borocode = dictionary["borocode"] as? String,
            let city = dictionary["city"] as? String,
            let houseNumber = dictionary["housenum"] as? String,
            
        let geo = dictionary["the_geom"] as? [String: AnyObject],
            let coord = geo["coordinates"] as? [Any],
            let latitude = coord[0] as? Double,
            let longitude = coord[1] as? Double,
            
            let name = dictionary["name"] as? String,
            let streetName = dictionary["streetname"] as? String,
            let system = dictionary["system"] as? String,
            let url = dictionary["url"] as? String,
            let zip = dictionary["zip"] as? String else { return nil }
        
        self.init(borocode: borocode, city: city, houseNumber: houseNumber, name: name, facilityName: name, streetAddress: streetName, system: system, url:url, zip: zip, latitude: latitude, longitude: longitude, facilityAddress: houseNumber + " " + streetName)
    }
    
    static func getLibraries(from data: Data) -> [Library] {
        var library: [Library] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let jsonArray = jsonData as? [[String: AnyObject]] else { return [] }
            
            for dictionary in jsonArray {
                guard let libraryDictionary = Library(dictionary: dictionary) else { continue }
                library.append(libraryDictionary)
            }
        } catch {
            print("problem parsing json: \(error)")
        }
        return library
    }
    
}
