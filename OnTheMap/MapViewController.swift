//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/4/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
	
	// MARK: - Properties
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		ParseClient.sharedInstance.getStudentLocations(){success, error in
			if success {
				self.mapView.addAnnotations( ParseClient.sharedInstance.studentAnnotations() )
			} else {
				ViewHelper.sharedInstance.displayError(self, errorString: error)
			}
		}

		
	}
	
	// MARK: - MKMapViewDelegate
	
	func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "pin"
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = UIColor.redColor()
			pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
		}
		else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	
	// This delegate method is implemented to respond to taps. It opens the system browser
	// to the URL specified in the annotationViews subtitle property.
	func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let app = UIApplication.sharedApplication()
			if let toOpen = view.annotation?.subtitle! {
				app.openURL(NSURL(string: toOpen)!)
			}
		}
	}
	
	@IBAction func logout(sender: AnyObject) {
		OTMClient.sharedInstance.taskForDELETEMethod("session") { (result, resultDictionary, error) in
			if result {
				dispatch_async(dispatch_get_main_queue(), {
					let logoutController = self.presentingViewController as? LoginViewController
					logoutController?.passwordField.text = ""
					let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewIdentifier") as? LoginViewController
					self.navigationController?.pushViewController(controller!, animated: true)
					self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil )
				})
			} else {
				ViewHelper.sharedInstance.displayError(self, errorString: error?.localizedDescription)
			}
		}
	}
	
}
