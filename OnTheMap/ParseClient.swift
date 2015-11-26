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
		let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation")!)
		request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
		let session = NSURLSession.sharedSession()

		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			guard error == nil else {
				completionHandler(success: false, errorString: error!.description)
				return
			}
			self.parseLocationData(data!) { success, error in
				completionHandler(success: success, errorString: nil)
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

