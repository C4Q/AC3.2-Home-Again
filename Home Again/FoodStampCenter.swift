//
//  FoodStampCenter.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

struct FoodStamp {
    
    var borough: String
    var city: String
    var facility_name: String
    var phone_number_s_: String
    var state: String
    var street_address: String
    var zip_code: String
    
    static func getJSONData(from data: Data) -> [FoodStamp]? {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [[String: String]] else { return nil }
            
            var getAllData: [FoodStamp] = []
            
            for eachData in dict{
                guard let boro = eachData["borough"],
                    let city = eachData["city"],
                    let facility = eachData["facility_name"],
                    let phoneNo = eachData["phone_number_s_"],
                    let state = eachData["state"],
                    let addr = eachData["street_address"],
                    let zipCode = eachData["zip_code"] else { return nil}
                
                let allData = FoodStamp(borough: boro, city: city, facility_name: facility, phone_number_s_: phoneNo, state: state, street_address: addr, zip_code: zipCode)
                    getAllData.append(allData)
            }
            
            return getAllData

          
        }catch{
            print("error")
        }
        
     return nil
    }
    
    
}
