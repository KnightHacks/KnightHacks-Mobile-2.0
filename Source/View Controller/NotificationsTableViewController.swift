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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateNavigationTitle()
        self.add(navigationController: navigationController, and: navigationItem, with: BACKGROUND_COLOR)
    }
    
    override public func willMove(toParent parent: UIViewController?) { }
    
    private func updateNavigationTitle() {
        self.navigationItem.title = "Notifications"
        self.navigationController?.navigationBar.tintColor = BACKGROUND_COLOR
        
        if #available(iOS 11, *) {
            self.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: CELL_HEADER_FONT
            ]
        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
