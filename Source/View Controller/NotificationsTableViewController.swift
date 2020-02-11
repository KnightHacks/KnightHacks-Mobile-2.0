//
//  NotificationsTableViewController.swift
//  KnightHacks
//
//  Created by Jamal Yauhari on 2/4/20.
//  Copyright © 2020 KnightHacks. All rights reserved.
//

import UIKit
import Firebase

class NotificationsTableViewController: NavigationBarTableViewController, NavigationBarViewControllerExtension {
    
    internal static let identifier: String = "NotificationsTableViewController"
    internal let messaging = Messaging.messaging()
    
    @IBOutlet weak var generalNotificationSwitch: UISwitch!
    @IBOutlet weak var foodNotificationSwitch: UISwitch!
    @IBOutlet weak var emergencyNotificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.largeTitleDisplayMode = .never
        generalNotificationSwitch.addTarget(self, action: #selector(controlGeneral(switchButton:)), for: .valueChanged)
        foodNotificationSwitch.addTarget(self, action: #selector(controlFood(switchButton:)), for: .valueChanged)
        emergencyNotificationSwitch.addTarget(self, action: #selector(controlEmergency(switchButton:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.updateNavigationTitle()
        self.setupNotificationSwitches()
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
    
    @objc private func controlGeneral(switchButton: UISwitch) {
        respondTo(switchButton, key: .isSubscribedToGeneralNotifications)
    }
    
    @objc private func controlFood(switchButton: UISwitch) {
        respondTo(switchButton, key: .isSubscribedToFoodNotifications)
    }
    
    @objc private func controlEmergency(switchButton: UISwitch) {
        respondTo(switchButton, key: .isSubscribedToEmergencyNotifications)
    }
    
    private func respondTo(_ switchButton: UISwitch, key: UserDefaultsHolder.RequestKey) {
        let shouldSubscribe = switchButton.isOn
        UserDefaultsHolder.set(value: shouldSubscribe, for: key)
        if shouldSubscribe {
            messaging.subscribe(toTopic: key.rawValue)
        } else {
            messaging.unsubscribe(fromTopic: key.rawValue)
        }
    }
    
    private func setupNotificationSwitches() {
        self.foodNotificationSwitch.isOn = !UserDefaultsHolder.exists(.isSubscribedToFoodNotifications) || UserDefaultsHolder.getUserDefaultValueFor(.isSubscribedToFoodNotifications)
        self.generalNotificationSwitch.isOn = !UserDefaultsHolder.exists(.isSubscribedToGeneralNotifications) || UserDefaultsHolder.getUserDefaultValueFor(.isSubscribedToGeneralNotifications)
        self.emergencyNotificationSwitch.isOn = !UserDefaultsHolder.exists(.isSubscribedToEmergencyNotifications) || UserDefaultsHolder.getUserDefaultValueFor(.isSubscribedToEmergencyNotifications)
    }
}
