//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/21/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import Foundation

class ParseClient {
	
	// MARK: Shared Instance
	
	static let sharedInstance = ParseClient()
	
	var students: [StudentLocation] = []
	
	
	// MARK: GET
	
	func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> ()) {
		let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURLSecure + "?limit=100&order=-updatedAt")!)
		request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		let session = NSURLSession.sharedSession()

		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			guard error == nil else {
				completionHandler(success: false, errorString: error!.description)
				return
			}
			self.parseLocationData(data!) { success, error in
				completionHandler(success: true, errorString: nil)
			}
		}
		task.resume()
	}
	
	func postStudentLocation(latitude: Double, longitude: Double, mapString: String, mediaURL: String, completionHandler: (success: Bool, errorString: String?) -> () ) {

		let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURLSecure)!)
		request.HTTPMethod = "POST"
		request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		let mutableParameters: [String: AnyObject] = [
			"uniqueKey": OTMClient.sharedInstance.userID!,
			"mapString": mapString,
			"mediaURL": mediaURL,
			"longitude": longitude,
			"latitude": latitude,
//			"firstName": "Ben",
			"lastName": "Johnston"
		]
		
		print(mutableParameters)
		
		do {
			request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(mutableParameters, options: .PrettyPrinted)
		}
		
		
		let session = NSURLSession.sharedSession()
//		test hound
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			do {
				let newParsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
				print("newParsedResult: \(newParsedResult)")
				if let parsedError = newParsedResult!["error"] { // Handle error…
					print("error: \(parsedError)")
				}
			} catch {
				print("could not parse data")
				
			}
			
		}
		task.resume()
		
	}
	
	func parseLocationData(data: NSData, completionHandler: (success: Bool, errorString: String?) -> Void) {

		// Clear out the array
		students.removeAll()
		
		// Get the users JSON data
		do {
			let usersData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary

			if let studentsData = usersData!["results"] as? [NSDictionary] {
				for student in studentsData {
					students.append(StudentLocation(data: student))
				}
			} else {
				// Error getting the dictionary from JSON data
				completionHandler(success: false, errorString: "Unable to locate results in JSON data")
				return
			}
		} catch {
			completionHandler(success: false, errorString: "Could not parse student data")
		}
		
		// Return successful
		completionHandler(success: true, errorString: nil)
	}
	
	
}

