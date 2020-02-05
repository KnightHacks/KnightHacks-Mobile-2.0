//
//  NotificationsTableViewController.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/4/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

class NotificationsTableViewController: NavigationBarTableViewController, NavigationBarViewControllerExtension {
    
    internal static let identifier: String = "NotificationsTableViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.colorUpper(view: tableView, with: BACKGROUND_COLOR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.add(navigationController: navigationController, and: navigationItem, with: BACKGROUND_COLOR)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
