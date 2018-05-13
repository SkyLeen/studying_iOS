//
//  MapVC.swift
//  myVKApp
//
//  Created by Natalya on 13/05/2018.
//  Copyright © 2018 Natalya Shikhalyova. All rights reserved.
//

import MapKit
import CoreLocation

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var currentPin: MKPointAnnotation?
    var selectedPin: MKPointAnnotation?
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var placeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchBar()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let pressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        pressRecognizer.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(pressRecognizer)
    }
    
    @objc func longPress(_ gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state != .began { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let coordinates = CLLocation(latitude: touchMapCoordinate.latitude, longitude: touchMapCoordinate.longitude)
        
        selectedPin = MKPointAnnotation()
        selectedPin?.coordinate = touchMapCoordinate
        selectedPin?.title = "Selected"
        interpretateCoords(coordinates) {
            self.selectedPin?.subtitle = self.placeName
        }
        
        mapView.addAnnotation(selectedPin!)
    }
    
    private func interpretateCoords(_ coords: CLLocation, closure: @escaping () -> Void) {
        geocoder.reverseGeocodeLocation(coords) { [weak self] places,error in
            if let place = places?.first {
                self?.placeName = place.country! + ", "  + place.locality! + ", " + place.name!
                closure()
            }
        }
    }
    
    private func createSearchBar() {
        let searchBar = UISearchBar()
        searchBar.keyboardType = .alphabet
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ID") as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "ID")
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.annotation = annotation
        
        return annotationView
    }
}
extension MapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            let currentRadius: CLLocationDistance = 1000
            let currentRegion = MKCoordinateRegionMakeWithDistance(currentLocation, currentRadius * 2.0, currentRadius * 2.0)
            
            let coordinates = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            currentPin = MKPointAnnotation()
            currentPin?.coordinate = currentLocation
            currentPin?.title = "My location"
            interpretateCoords(coordinates) {
                self.currentPin?.subtitle = self.placeName
            }
            
            mapView.setRegion(currentRegion, animated: true)
            mapView.showsUserLocation = true
            mapView.addAnnotation(currentPin!)
        }
    }
}

extension MapVC: UISearchBarDelegate {
    
}

