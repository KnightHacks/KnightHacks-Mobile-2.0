//
//  MapViewController.swift
//  KnightHacks
//
//  Created by Patrick Stoebenau on 11/10/19.
//  Copyright © 2019 KnightHacks. All rights reserved.
//

import UIKit

internal class MapViewController: UIViewController, UIScrollViewDelegate {
    
    internal static let identifier: String = "MapViewController"
    
    @IBOutlet weak var mapImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapImage.image = UIImage(named: "map")
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mapImage
    }
    
    func setMapImage(_ mapImageURL: String) {
        ImageRequestSingleton.firebaseGetImage(reference: mapImageURL) { (image) in
            self.mapImage.image = image
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
