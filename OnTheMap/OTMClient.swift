//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/9/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import Foundation

class OTMClient {
	// MARK: Properties
	
	/* Shared session */
	var session: NSURLSession
	
	/* Authentication state */
	var sessionID : String? = nil
	var userID : String? = nil
	var firstName: String? = nil
	var lastName: String? = nil
	
	// MARK: Initializers
	
	init() {
		session = NSURLSession.sharedSession()
	}
	
	// MARK: Shared Instance
	
	static let sharedInstance = OTMClient()
	
	// MARK: GET
	
	func taskForGETMethod(method: String, completionHandler: (result: Bool, resultDictionary: [String: AnyObject]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
		
		/* 1. Set the parameters */

		
		/* 2/3. Build the URL and configure the request */
		let urlString = Constants.BaseURLSecure + method
		let url = NSURL(string: urlString)!
		let request = NSURLRequest(URL: url)
		
		print("request: \(request)")
		
		/* 4. Make the request */
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				print("There was an error with your request: \(error)")
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
				return
			}
			
			/* GUARD: Was there any data returned? */
			guard let data = data else {
				print("No data was returned by the request!")
				return
			}
			
			/* 5/6. Parse the data and use the data (happens in completion handler) */
			OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	// MARK: POST
	
	func taskForPOSTMethod(method: String, parameters: [String : AnyObject] = ["":""], jsonBody: [String:AnyObject], completionHandler: (result: Bool, resultDictionary: [String: AnyObject]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
		
		/* 1. Set the parameters */
		let mutableParameters = parameters
		
		/* 2/3. Build the URL and configure the request */
		let urlString = Constants.BaseURLSecure + method + OTMClient.escapedParameters(mutableParameters)
		let url = NSURL(string: urlString)!
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		do {
			request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
		}
		
		/* 4. Make the request */
		let task = session.dataTaskWithRequest(request) { (data, response, error) in
			print("request: \(request)")
			
			/* GUARD: Was there an error? */
			guard (error == nil) else {
				print("There was an error with your request: \(error)")
				completionHandler(result: false, resultDictionary: nil, error: error)
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
				OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
				return
			}
			
			/* 5/6. Parse the data and use the data (happens in completion handler) */
			OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
		}
		
		/* 7. Start the request */
		task.resume()
		
		return task
	}
	
	// MARK: DELETE
	
	func taskForDELETEMethod(method: String, completionHandler: (result: Bool, resultDictionary: [String: AnyObject]?, error: NSError?) -> Void) -> NSURLSessionDataTask {
		
		let urlString = Constants.BaseURLSecure + method
		let url = NSURL(string: urlString)!
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "DELETE"
		
		var xsrfCookie: NSHTTPCookie? = nil
		let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
		for cookie in (sharedCookieStorage.cookies)! {
			if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
		}
		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
		}
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request) { data, response, error in

			/* GUARD: Was there an error? */
			guard (error == nil) else {
				print("There was an error with your request: \(error)")
				completionHandler(result: false, resultDictionary: nil, error: error)
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
				OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
				return
			}
			
			/* 5/6. Parse the data and use the data (happens in completion handler) */
			OTMClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)

		}
		task.resume()
		return task
	}

	
	// MARK: Helpers	
	
	/* Helper: Given raw JSON, return a usable Foundation object */
	class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: Bool, resultDictionary: [String: AnyObject]?, error: NSError?) -> Void) {
		
		do {
			let newParsedResult = try NSJSONSerialization.JSONObjectWithData(data.subdataWithRange(NSMakeRange(5, data.length - 5)), options: .AllowFragments) as? [String: AnyObject]
			completionHandler(result: true, resultDictionary: newParsedResult, error: nil)
		} catch {
			let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
			completionHandler(result: false, resultDictionary: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
		}
		
		
	}
	
	/* Helper function: Given a dictionary of parameters, convert to a string for a url */
	class func escapedParameters(parameters: [String : AnyObject]) -> String {
		
		var urlVars = [String]()
		
		for (key, value) in parameters {
			
			/* Make sure that it is a string value */
			let stringValue = "\(value)"
			
			/* Escape it */
			let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
			
			/* Append it */
			urlVars += [key + "=" + "\(escapedValue!)"]
			
		}
		
		return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
	}
	
}