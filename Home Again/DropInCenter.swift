//
//  DropInCenter.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct DropInCenter: ResourcesTable {
    let type = "shelter"
    let borough: String
    let facilityName: String
    let hoursOfOperation: String
    let facilityAddress: String
    
    init(borough: String, centerName: String, hoursOfOperation: String, location: String) {
        self.borough = borough
        self.facilityName = centerName
        self.hoursOfOperation = hoursOfOperation
        self.facilityAddress = location
    }
    
    init?(dictionary: [String : Any]) {
        guard let borough = dictionary["borough"] as? String,
            let facilityName = dictionary["center_name"] as? String,
            let hoursOfOperation = dictionary["comments"] as? String,
            let location = dictionary["location_1_location"] as? String else { return nil }
        
        self.init(borough: borough, centerName: facilityName, hoursOfOperation: hoursOfOperation, location: location)
    }
    
    static func getDropInCenters(from data: Data) -> [DropInCenter] {
        var dropInCenters: [DropInCenter] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonData as? [[String: Any]] else { return [] }
            
            for dictionary in jsonArray {
                guard let dropInCenterDictionary = DropInCenter(dictionary: dictionary) else { continue }
                dropInCenters.append(dropInCenterDictionary)
            }
        } catch {
            print("problem parsing json: \(error)")
        }
        return dropInCenters
    }
}
