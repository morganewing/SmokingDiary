//
//  NetworkManager.swift
//  SmokingDiary
//
//  Created by Morgan Ewing on 11/07/2017.
//  Copyright © 2017 Morgan Ewing. All rights reserved.
//

import Alamofire

enum NetworkError {
    case BadParameters
    case BadConnection
}

var editArray: NSArray! = []

// Network manager class
class NetworkManager {

    typealias JSON = [String: Any]

    let API_URL = "https://wt-96a40030c5d2a13282018030d32db7a4-0.run.webtask.io/SmokingDiary"
    let username = "Morgan"
    
    func deleteEntry(username: String, uniqueId: Int, completion:  @escaping (_ entries: [Entry], _ error: NetworkError?) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "method": "delete",
            "uniqueId": uniqueId
            
        ]
        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
        }

    }
    
    // Get an entry
    func getEntry(username: String, uniqueId: Int, completion: @escaping (_ entry: [Entry]) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "method": "get",
            "uniqueId": uniqueId
        ]
        
        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let json):
                
                guard let _json = json as? JSON,
                    let entry = _json["entry"] as? [JSON] else {
                        completion([])
                        return
                }
                var entryObjects: [Entry] = []
                for ent in entry {
                    guard let username = ent["username"] as? String,
                        let date = ent["date"] as? String,
                        let numcig = ent["numcig"] as? Int,
                        let activity = ent["activity"] as? [String],
                        let location = ent["location"] as? [String],
                        let people = ent["people"] as? [String],
                        let mood = ent["mood"] as? [String],
                        let uniqueId = ent["uniqueId"] as? Int else {
                            continue
                    }
                    entryObjects.append(Entry(username: username, date: date, numcig: numcig, activity: activity, location: location, people: people, mood: mood, uniqueId: uniqueId))
                }
                completion(entryObjects)
            case .failure(_):
                completion([])
            }
        }

    }
    
    // Return list of entries
    func listEntries(for username: String, completion: @escaping (_ entries: [Entry]) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "method": "list"
        ]

        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            switch response.result {
            case .success(let json):

                guard let _json = json as? JSON,
                    let entries = _json["entries"] as? [JSON] else {
                    completion([])
                    return
                }
                var entryObjects: [Entry] = []
                for entry in entries {
                    guard let username = entry["username"] as? String,
                        let date = entry["date"] as? String,
                        let numcig = entry["numcig"] as? Int,
                        let activity = entry["activity"] as? [String],
                        let location = entry["location"] as? [String],
                        let people = entry["people"] as? [String],
                        let mood = entry["mood"] as? [String],
                        let uniqueId = entry["uniqueId"] as? Int else {
                        continue
                    }
                    entryObjects.append(Entry(username: username, date: date, numcig: numcig, activity: activity, location: location, people: people, mood: mood, uniqueId: uniqueId))
                }
                completion(entryObjects)
            case .failure(_):
                completion([])
            }
        }
    }

    // Save an entry
    func saveEntry(dateTime: String, numCigs: Int, activityList: [String], locationList: [String], peopleList: [String], moodList: [String], method: String, completion: @escaping (_ entries: [Entry], _ error: NetworkError?) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "date": dateTime,
            "numcig": numCigs,
            "activity": activityList,
            "location": locationList,
            "people": peopleList,
            "mood": moodList,
            "method": "add"
        ]
        
        // Post method
        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            // Check data
            
            print(response)
        }
    }
    
    // Edit an entry
    func editEntry(dateTime: String, numCigs: Int, activityList: [String], locationList: [String], peopleList: [String], moodList: [String], uniqueId: Int, method: String, completion: @escaping (_ entries: [Entry], _ error: NetworkError?) -> Void) {
        let parameters: Parameters = [
            "username": username,
            "date": dateTime,
            "numcig": numCigs,
            "activity": activityList,
            "location": locationList,
            "people": peopleList,
            "mood": moodList,
            "uniqueId": uniqueId,
            "method": "edit"
        ]
        
        Alamofire.request(API_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            // Check data
            
            print(response)
        }
    }

}
