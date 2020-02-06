//
//  GroupsTableViewController.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/6/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit

class GroupsTableViewController: NavigationBarViewController, NavigationBarViewControllerExtension {
    
    internal static let identifier: String = "GroupsTableViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateNavigationTitle()
        self.add(navigationController: navigationController, and: navigationItem, with: BACKGROUND_COLOR)
    }
    
    private func updateNavigationTitle() {
        self.navigationItem.title = "Groups"
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
