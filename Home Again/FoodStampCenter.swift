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
    var facilityName: String
    var phoneNumber: String
    var state: String
    var facilityAddress: String
    var zipCode: String
    
    static func getFoodStamps(from data: Data) -> [FoodStamp] {
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [[String: String]] else { return [] }
            
            var foodStamps: [FoodStamp] = []
            
            for eachData in dict{
                guard let boro = eachData["borough"],
                    let city = eachData["city"],
                    let facility = eachData["facility_name"],
                    let phoneNo = eachData["phone_number_s_"],
                    let state = eachData["state"],
                    let address = eachData["street_address"],
                    let zipCode = eachData["zip_code"] else { continue }
                
                let validFoodStamp = FoodStamp(borough: boro,
                                               city: city,
                                               facilityName: facility,
                                               phoneNumber: phoneNo,
                                               state: state,
                                               facilityAddress: address,
                                               zipCode: zipCode)
                
                    foodStamps.append(validFoodStamp)
            }
            
            return foodStamps
          
        }
        catch {
            print("error")
        }
     return []
    }
    
    
}
