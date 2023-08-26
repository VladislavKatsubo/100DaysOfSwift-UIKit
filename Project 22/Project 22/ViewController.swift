//
//  ViewController.swift
//  Project 22
//
//  Created by Vlad Katsubo on 6/8/22.
//

import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var distance: UILabel!
    @IBOutlet var circle: UIView!
    
    
    var locationManager: CLLocationManager?
    var showedAlert: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        circle.layer.zPosition = 1
        circle.layer.cornerRadius = 128
        circle.layer.backgroundColor = UIColor.lightGray.cgColor
        circle.layer.borderColor = UIColor.blue.cgColor
        
        locationManager = CLLocationManager()
        
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .lightGray
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let id = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: id, major: 123, minor: 456, identifier: "MyBeacon")
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .far:
                UIView.animate(withDuration: 1) {
                    self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                }
                self.view.backgroundColor = .blue
                self.distance.text = "Far"
            case .near:
                UIView.animate(withDuration: 1) {
                    self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
                self.view.backgroundColor = .orange
                self.distance.text = "Near"
            case .immediate:
                UIView.animate(withDuration: 1) {
                    self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                self.view.backgroundColor = .green
                self.distance.text = "Right Here"
                
            default:
                UIView.animate(withDuration: 1) {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
                self.view.backgroundColor = .white
                self.distance.text = "UNKNOWN"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
            showAlert()
        } else {
            update(distance: .unknown)
            showAlert()
        }
    }
    
    func showAlert() {
        if !showedAlert {
            let bc = UIAlertController(title: "Hey!", message: "I've found something...", preferredStyle: .alert)
            bc.addAction(UIAlertAction(title: "Nice!", style: .cancel))
            present(bc, animated: true)
        }
        showedAlert = false
    }

}

