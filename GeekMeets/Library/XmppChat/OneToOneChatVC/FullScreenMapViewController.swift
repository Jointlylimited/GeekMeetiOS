//
//  FullScreenMapViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 07/07/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import MapKit

class FullScreenMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var chatMsg : Model_ChatMessage?
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLocationOnMap()
        // Do any additional setup after loading the view.
    }
    
    func showLocationOnMap(){
        
        let regionRadius: CLLocationDistance = 1000
        let latStr = self.chatMsg?.strMsg?.split(",").first
        let lonStr = self.chatMsg?.strMsg?.split(",").last
        print("\(latStr) \(lonStr)")
        
        if latStr != nil && lonStr != nil {
            let Location = CLLocationCoordinate2D(latitude: Double(latStr!)!, longitude:  Double(lonStr!)!)
            let viewRegion = MKCoordinateRegion(center: Location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(viewRegion, animated: true)
            
            annotation.coordinate = Location
            mapView.addAnnotation(annotation)
        }
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
}
