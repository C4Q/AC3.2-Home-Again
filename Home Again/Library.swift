//
//  Library.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct Library {
    let borocode: String
    let city: String
    let houseNumber: String
    let name: String
    let streetName: String
    let system: String
    let url: String
    let zip: String
    let latitude: String
    let longitude: String
    
    init(borocode: String, city: String, houseNumber: String, name: String, streetName: String, system: String, url: String, zip: String, latitude: String, longitude: String) {
        self.borocode = borocode
        self.city = city
        self.houseNumber = houseNumber
        self.name = name
        self.streetName = streetName
        self.system = system
        self.url = url
        self.zip = zip
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let borocode = dictionary["borocode"] as? String,
            let city = dictionary["city"] as? String,
            let houseNumber = dictionary["housenum"] as? String,
            
            let latitude = dictionary["coordinates"]?[0] as? String,
            let longitude = dictionary["coordinates"]? [1] as? String,
            
            let name = dictionary["name"] as? String,
            let streetName = dictionary["streetname"] as? String,
            let system = dictionary["system"] as? String,
            let url = dictionary["url"] as? String,
            let zip = dictionary["zip"] as? String else { return nil }
        
        self.init(borocode: borocode, city: city, houseNumber: houseNumber, name: name, streetName: streetName, system: system, url:url, zip: zip, latitude: latitude, longitude: longitude)
    }
    
    static func getDropInCenters(from data: Data) -> [Library] {
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
