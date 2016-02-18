//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/18/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation {	
	
	let createdAt, firstName, lastName, mapString, mediaURL, objectId, uniqueKey, updatedAt: String
	let annotation = MKPointAnnotation()
	
	init(data: NSDictionary){
		self.createdAt = data["createdAt"] as! String
		self.firstName = data["firstName"] as! String
		self.lastName = data["lastName"] as! String
		self.mapString = data["mapString"] as! String
		self.mediaURL = data["mediaURL"] as! String
		self.objectId = data["objectId"] as! String
		self.uniqueKey = data["uniqueKey"] as! String
		self.updatedAt = data["updatedAt"] as! String
		setAnnotation(data)
	}
	
	func setAnnotation(data: NSDictionary) {
		let lat = CLLocationDegrees(data["latitude"] as! Double)
		let long = CLLocationDegrees(data["longitude"] as! Double)
		annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
		annotation.title = "\(firstName) \(lastName)"
		annotation.subtitle = mediaURL
	}
}
