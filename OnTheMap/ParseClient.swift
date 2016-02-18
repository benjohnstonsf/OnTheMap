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
	
	// MARK: GET
	
	func getStudentLocations(completionHandler: (success: Bool, errorString: String?) -> ()) {
		let request = NSMutableURLRequest(URL: NSURL(string: Constants.BaseURLSecure + "?limit=100&order=-updatedAt")!)
		request.addValue(Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		let session = NSURLSession.sharedSession()

		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			guard error == nil else {
				completionHandler(success: false, errorString: error?.localizedDescription)
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				print("No data was returned by the request!")
				return
			}
			
			/* GUARD: Did we get a successful 2XX response? */
			guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
				if let response = response as? NSHTTPURLResponse {
					print("Your request returned an invalid response! Status code: \(response.statusCode)!")
				} else if let response = response {
					print("Your request returned an invalid response! Response: \(response)!")
				} else {
					print("Your request returned an invalid response!")
				}
				self.parseLocationData(data) { success, error in
					completionHandler(success: false, errorString: "Server error")
				}
				return
			}
			
			
			self.parseLocationData(data) { success, error in
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
			"firstName": OTMClient.sharedInstance.firstName!,
			"lastName": OTMClient.sharedInstance.lastName!
		]
		
		do {
			request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(mutableParameters, options: .PrettyPrinted)
		}
		
		
		let session = NSURLSession.sharedSession()
		
		let task = session.dataTaskWithRequest(request) { data, response, error in
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				print("There was an error with your request: \(error)")
				completionHandler(success: false, errorString: error?.localizedDescription)
				return
			}
			
			do {
				let newParsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? [String: AnyObject]
				if let parsedError = newParsedResult!["error"] { // Handle error…
					completionHandler(success: false, errorString: parsedError as? String)
				} else {
					completionHandler(success: true, errorString: nil)
				}
			} catch {
				let errorInfo = "There was an error posting your info, please try again"
				completionHandler(success: false, errorString: errorInfo)
			}			
		}
		task.resume()
		
	}
	
	func parseLocationData(data: NSData, completionHandler: (success: Bool, errorString: String?) -> Void) {

		// Clear out the array
		StudentInformation.sharedInstance.students.removeAll()
		
		// Get the users JSON data
		do {
			let usersData = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary

			if let studentsData = usersData!["results"] as? [NSDictionary] {
				for student in studentsData {
					StudentInformation.sharedInstance.students.append(StudentLocation(data: student))
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

