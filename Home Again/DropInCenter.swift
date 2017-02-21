//
//  DropInCenter.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct DropInCenter: ResourcesTable {
    
    enum ZipCode: String {
        case Mainchance = "10016"
        case Center = "10001"
        case Hospitality = "10304"
        case Place = "11226"
        case Room = "10474"
    }
    
    let type = "shelter"
    let borough: String
    let facilityName: String
    let hoursOfOperation: String
    let facilityAddress: String
    var zipCode = ""
    
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
                guard var dropInCenterDictionary = DropInCenter(dictionary: dictionary) else { continue }
                
                let zipCode = getZip(dropInCenterDictionary.facilityAddress)
                dropInCenterDictionary.zipCode = zipCode
                print(zipCode)
                dropInCenters.append(dropInCenterDictionary)
            }
        } catch {
            print("problem parsing json: \(error)")
        }
        return dropInCenters
    }
    
    static func getZip(_ address: String) -> String {
        var zip = ""
        APIRequestManager.manager.getData(endPoint: "https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=9f38ae63&app_key=cd84b648110b8ee65df34f449aee7c1e&input=\(address)") { (data) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonArray = jsonData as? [String: Any],
                    let results = jsonArray["results"] as? [[String: Any]],
                    let response = results[0]["response"] as? [String: Any] {
                    
                    guard let zipCode = response["zipCode"] as? String else { return }
                    zip = zipCode
                }
            }
            catch {
                print(error)
            }
        }
        return zip
    }
}
