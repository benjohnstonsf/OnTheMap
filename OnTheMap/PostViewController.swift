//
//  PostViewController.swift
//  OnTheMap
//
//  Created by Benjamin Johnston on 12/15/15.
//  Copyright © 2015 Benjamin Johnston. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
	
	// MARK: - Properties
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - Actions	

	@IBAction func cancelPost(sender: AnyObject) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}


}
