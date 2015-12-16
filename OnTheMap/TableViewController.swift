//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 11/4/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import UIKit


class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {	
	
	@IBOutlet weak var studentTableView: UITableView!
	var delegate = self
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let CellReuseId = "StudentCell"
		let student = ParseClient.sharedInstance.students[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier(CellReuseId) as UITableViewCell!
		cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
		
		return cell
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ParseClient.sharedInstance.students.count
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let cell = ParseClient.sharedInstance.students[indexPath.row]

		let app = UIApplication.sharedApplication()
		if let toOpen = cell.annotation.subtitle {
			app.openURL(NSURL(string: toOpen)!)
		}
	
	}
	
	
	@IBAction func logout(sender: AnyObject) {
		OTMClient.sharedInstance.udacityDestroySession(self)
	}
	
	
}

