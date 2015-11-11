//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/4/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	// MARK: - Properties
	
	@IBOutlet weak var emailField: UITextField!
	@IBOutlet weak var passwordField: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var errorMessage: UILabel!
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// MARK: - Actions
	
	@IBAction func pressLogin(sender: AnyObject) {
		let authDetails = (self.emailField.text, self.passwordField.text)
		OTMClient.sharedInstance.udacityCreateSession(authDetails) { (success, errorString) in
			if success {
				self.completeLogin()
			} else {
				self.displayError(errorString)
			}
		}
	}
	
	// MARK: LoginViewController
	
	func completeLogin() {
		dispatch_async(dispatch_get_main_queue(), {
			self.errorMessage.text = ""
			let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapNavigationController")
			self.presentViewController(controller, animated: true, completion: nil)
		})
	}
	
    // MARK: - Modify UI
	
	func displayError(errorString: String?){
		dispatch_async(dispatch_get_main_queue(), {
			if let errorString = errorString {
				self.errorMessage.text = errorString
			}
		})
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}
