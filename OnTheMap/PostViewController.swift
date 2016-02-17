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
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
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
		ParseClient.sharedInstance.postStudentLocation(location.coordinate.latitude, longitude: location.coordinate.longitude, mapString: locationInput.text!, mediaURL: linkInput.text!) {
			success, error in
			guard error == nil else {
				ViewHelper.sharedInstance.displayError(self, errorString: error)
				return
			}
			dispatch_async(dispatch_get_main_queue(), {
				let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController")
				self.presentViewController(controller, animated: true, completion: nil)
			})
		}
	}
	
	// MARK: - Actions	

	@IBAction func cancelPost(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func findLocationButtonPressed(sender: AnyObject) {
		locationInput.alpha = 0.9
		activityIndicator.startAnimating()
		forwardGeocode(locationInput.text!) {
			location in
			self.location = location
			self.mapView.hidden = false
			self.centerMapOnLocation(self.location!)
			self.setupLinkView()
			self.activityIndicator.stopAnimating()
		}
		locationInput.alpha = 0.0
	}
	
	@IBAction func submitLocationButtonPressed(sender: AnyObject) {
		guard linkInput.hasText() else {
			ViewHelper.sharedInstance.displayError(self, errorString: "Please enter a link")
			return
		}
		submitNewLocation(self.location!)
	}



}
