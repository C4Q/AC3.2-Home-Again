//
//  DropInCenter.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct DropInCenter {
    
    
    let borough: String
    let centerName: String
    let hoursOfOperation: String
    let location: String
    
    init(borough: String, centerName: String, hoursOfOperation: String, location: String) {
        self.borough = borough
        self.centerName = centerName
        self.hoursOfOperation = hoursOfOperation
        self.location = location
    }
    
    init?(dictionary: [String : Any]) {
        guard let borough = dictionary["borough"] as? String,
            let centerName = dictionary["center_name"] as? String,
            let hoursOfOperation = dictionary["comments"] as? String,
            let location = dictionary["location_1_location"] as? String else {return nil}
        
        self.init(borough: borough, centerName: centerName, hoursOfOperation: hoursOfOperation, location: location)
    }
    
    static func buildDropInCenterArray(from data: Data) -> [DropInCenter]? {
        var dropInCenterArray: [DropInCenter] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonData as? [[String: Any]] else {return nil}
            
            for dictionary in jsonArray {
                guard let dropInCenterDictionary = DropInCenter(dictionary: dictionary) else {continue}
                dropInCenterArray.append(dropInCenterDictionary)
            }
        } catch {
            print("problem parsing json: \(error)")
        }
        return dropInCenterArray
    }
}
