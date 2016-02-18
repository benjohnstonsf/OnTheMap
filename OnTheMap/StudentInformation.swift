//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 2/17/16.
//  Copyright © 2016 Benjamin Johnston. All rights reserved.
//

import Foundation
import MapKit

class StudentInformation {
	static let sharedInstance = StudentInformation()
	var students: [StudentLocation] = []
	
	func studentAnnotations() -> [MKAnnotation] {
		let locations = StudentInformation.sharedInstance.students
		var annotations = [MKAnnotation]()
		for student in locations {
			annotations.append(student.annotation)
		}
		return annotations
	}
}
