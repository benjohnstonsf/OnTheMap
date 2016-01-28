//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 12/15/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
	
	// MARK: - Properties
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var titleMessage: UILabel!
	@IBOutlet weak var findLocationButton: UIButton!
	@IBOutlet weak var locationInput: UITextField!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var submitButton: UIButton!
	@IBOutlet weak var linkInput: UITextField!
	
	var location: CLLocation?
	
	
	// MARK: - Helpers
	
	func forwardGeocode(input: String, setLocation: (CLLocation) -> () ) {
		let geoCode = CLGeocoder()
		geoCode.geocodeAddressString(input) {
			placemarks, error in
			guard error == nil else {
				ViewHelper.sharedInstance.displayError(self, errorString: error.debugDescription)
				return
			}
			if let firstPlacemarkLocation = placemarks?[0].location {
				setLocation(firstPlacemarkLocation)

			}
		}
	}
	
	
	
	func setupLinkView() {
		submitButton.hidden = false
		titleMessage.hidden = true
		linkInput.hidden = false
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let regionRadius: CLLocationDistance = 1000
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
		mapView.setRegion(coordinateRegion, animated: true)
		
		let dropPin = MKPointAnnotation()
		dropPin.coordinate = location.coordinate
		dropPin.title = "Your Location"
		mapView.addAnnotation(dropPin)
	}
	
	func submitNewLocation(location: CLLocation) {
		print("link submitted")
		
	}
	
	// MARK: - Actions	

	@IBAction func cancelPost(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func findLocationButtonPressed(sender: AnyObject) {
		forwardGeocode(locationInput.text!) {
			location in
			self.location = location
			self.mapView.hidden = false
			self.centerMapOnLocation(self.location!)
			self.setupLinkView()
			print(location)
		}
	}
	
	@IBAction func submitLocationButtonPressed(sender: AnyObject) {
		guard linkInput.hasText() else {
			ViewHelper.sharedInstance.displayError(self, errorString: "Please enter a link")
			return
		}
		submitNewLocation(self.location!)
	}



}
