//
//  AnimationViewController.swift
//  KnightHacks
//
//  Created by Lloyd Dapaah on 12/22/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit
import Lottie

public class AnimationHolder: UIViewController {
    
    var animationView: AnimationView!
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(frame: CGRect) {
        super.init(nibName: nil, bundle: nil)
        self.animationView = AnimationView(frame: frame)
        
        self.view = self.animationView
        self.view.frame = frame
        self.view.backgroundColor = UIColor(red: 23, green: 46, blue: 115, a: 1)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        let starAnimation = Animation.named("light-launch-animation")
        animationView.animationSpeed = 1.3
        animationView.animation = starAnimation
        animationView.contentMode = .scaleAspectFit
        animationView.play { (_) in
            let mainBundle: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = mainBundle.instantiateViewController(withIdentifier: "MainNavigationViewController")
            mainViewController.modalTransitionStyle = .crossDissolve
            self.present(mainViewController, animated: true, completion: nil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
