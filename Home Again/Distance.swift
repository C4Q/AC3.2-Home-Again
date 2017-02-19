//
//  Distance.swift
//  Home Again
//
//  Created by Margaret Ikeda on 2/18/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import Foundation

class Distance {
    let facilityAddress: String
    let theCurrentLocationString: String
    
    init(facilityAddress: String, theCurrentLocationString: String){
        self.facilityAddress = facilityAddress
        self.theCurrentLocationString = theCurrentLocationString
    }
    static func getDistance(data: Data) -> [Distance]? {
        var distanceArray = [Distance]()
        let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
        dump(jsonData)
        guard let jsonAsDict = jsonData as? [String : Any] else {
            print("No response")
            return nil
        }
        guard let rows = jsonData as? [[String: Any]] else {
            return nil
        }
        guard let elements = rows as? [[String: Any]] else {
            return nil
        }
        guard let distanceDict = elements as? [String: Any] else {
            return nil
        }
        for everyText in distanceDict {
            guard let dictOfDictContainingText = distanceDict["texts"] as? [String : Any] else {
                return nil
            }
//            if let theDistance = Distance(withDictionary: distanceDict) {
//                distanceArray.append(theDistance)
//            }
        }
        return distanceArray
    }
}


