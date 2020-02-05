//
//  NotificationsViewController.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/5/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import Foundation
import UIKit

class NotificationsViewController: NavigationBarViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateNavigationTitle()
    }
    
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
