//
//  JobCenter.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class JobCenter: ResourcesTable {
    let type = "job"
    let borough: String
    let city: String
    let facilityName: String
    let phoneNumber: String
    let state: String
    let facilityAddress: String
    let zipCode: String
    
    init (borough: String,  city: String, facilityName: String, phoneNumber: String, state: String,
          facilityAddress: String, zipCode: String) {
        self.borough = borough
        self.city = city
        self.facilityName = facilityName
        self.phoneNumber = phoneNumber
        self.state = state
        self.facilityAddress = facilityAddress
        self.zipCode = zipCode
    }
    
    convenience init?(dictionary: [String: Any]){
        guard let borough = dictionary["borough"] as? String,
            let city = dictionary["city"] as? String,
            let facilityName = dictionary["facility_name"] as? String,
            let phoneNumber = dictionary["phone_number_s"] as? String,
            let state = dictionary["state"] as? String,
            let streetAddress = dictionary["street_address"] as? String,
            let zipCode = dictionary["zip_code"] as? String else {return nil}
        
        self.init(borough: borough, city: city, facilityName: facilityName, phoneNumber: phoneNumber, state: state, facilityAddress: streetAddress, zipCode: zipCode)
    }
    
    static func getJobCenters(from data: Data) -> [JobCenter] {
        var jobCenters: [JobCenter] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonArray = jsonData as? [[String: Any]] else { return [] }
            
            for dictionary in jsonArray {
                guard let jobDictionary = JobCenter(dictionary: dictionary) else { continue }
                jobCenters.append(jobDictionary)
            }
        } catch {
            print("problem parsing json: \(error)")
        }
        return jobCenters
    }
}
