//
//  ViewController.swift
//  Test
//
//  Created by Arkadiy Grigoryanc on 31.05.17.
//  Copyright © 2017 Arkadiy Grigoryanc. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    fileprivate var coordinate: CLLocationCoordinate2D? {
        
        didSet {
            
            if let coordinate = coordinate {
                
                latitudeLabel.text = String(coordinate.latitude)
                longitudeLabel.text = String(coordinate.longitude)
                
            } else {
                
                latitudeLabel.text = "-"
                longitudeLabel.text = "-"
                
            }
            
        }
        
    }
    
    fileprivate var accuracy: CLLocationAccuracy? {
        
        didSet {
            
            accuracyLabel.text = accuracy != nil ? String(accuracy!) + " м." : "-"
            
        }
        
    }
    
    private lazy var locationManager: CLLocationManager = {
        
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        
        return _locationManager
        
    }()
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func actionLocate(_ sender: Any) {
        
        // Request authorization location
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            // Set accuracy
            locationManager.desiredAccuracy = 60.0 // 60 meters
            
            // Request location
            locationManager.requestLocation()
            
            // Start activity indicator
            activityIndicator.startAnimating()
            
        }
        
    }
    
    // MARK: - Private methods
    
    fileprivate func clearData() {
        
        coordinate = nil
        accuracy = nil
        
    }
    
}


extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let accuracy = locations.last?.horizontalAccuracy {
            
            if accuracy <= manager.desiredAccuracy {
                
                self.coordinate = locations.last!.coordinate
                self.accuracy = accuracy
                
            } else {
                
                let alertController = UIAlertController(title: "Предупреждение!",
                                                        message: "Слишком высокая погрешность: \(String(accuracy)) м. Попробуйте снова.",
                                                        preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ок",
                                                 style: .cancel,
                                                 handler: nil)
                
                alertController.addAction(cancelAction)
                
                present(alertController, animated: true) {
                    
                    // Clear data
                    self.clearData()
                    
                }
                
            }
            
        }
        
        // Stop activity indicator
        activityIndicator.stopAnimating()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
        let alertController = UIAlertController(title: "Ошибка!",
                                                message: "Попробуйте снова.",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Ок",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            
            // Clear data
            self.clearData()
            
        }
        
        // Stop activity indicator
        activityIndicator.stopAnimating()
        
    }
    
}















