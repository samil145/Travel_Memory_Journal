//
//  MapViewController.swift
//  Travel Memory Journal
//
//  Created by Shamil Bayramli on 01.02.24.
//

import UIKit
import MapKit

protocol MapViewControllerDelegate: AnyObject
{
    func backFromMapView()
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView = MKMapView()
    let locationManager = CLLocationManager()
    let scale: CGFloat = 300
    
    weak var delegate: MapViewControllerDelegate?
    
    var cityName: String?
    var countryName: String?
    
    var selectedAnnotation: MKPointAnnotation?
    {
        didSet
        {
            buttonDone.isEnabled = true
        }
    }
    
    let mapTypes = ["Hybrid": MKMapType.hybrid, "Satellite": MKMapType.satellite, "Standard": MKMapType.standard]
    
    let buttonMap: UIButton =
    {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(rgb: 0x1C1C1C)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonLocation: UIButton =
    {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(rgb: 0x1C1C1C)
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.imageView?.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buttonDone: UIButton =
    {
        let button = UIButton()
        button.configuration = .filled()
        button.isEnabled = false
        button.configuration?.title = "Done"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configurationUpdateHandler = {
            button in
            if (!button.isEnabled)
            {
                button.configuration?.background.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
            }
            else
            {
                button.configuration?.background.backgroundColor = UIColor.systemBlue
            }
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates
        locationManager.delegate = self
        mapView.delegate = self
        
        // Map View Configuration
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        
        self.view.addSubview(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
        
        view.addSubview(buttonMap)
        view.addSubview(buttonLocation)
        view.addSubview(buttonDone)
        
        NSLayoutConstraint.activate([
            buttonMap.widthAnchor.constraint(equalToConstant: 55),
            buttonMap.heightAnchor.constraint(equalToConstant: 55),
            buttonMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            buttonMap.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            buttonLocation.widthAnchor.constraint(equalToConstant: 55),
            buttonLocation.heightAnchor.constraint(equalToConstant: 55),
            buttonLocation.centerXAnchor.constraint(equalTo: buttonMap.centerXAnchor),
            buttonLocation.topAnchor.constraint(equalTo: buttonMap.bottomAnchor, constant: 20),
            
            buttonDone.heightAnchor.constraint(equalToConstant: 55),
            buttonDone.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            buttonDone.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonDone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
        
        buttonLocation.addTarget(self, action: #selector(goCurrentLocation), for: .touchUpInside)
        buttonMap.addTarget(self, action: #selector(changeType_), for: .touchUpInside)
        buttonDone.addTarget(self, action: #selector(mapDone), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        mapView.frame = view.bounds.inset(by: UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0))
        
        buttonMap.layer.cornerRadius = buttonMap.bounds.size.width/2
        buttonLocation.layer.cornerRadius = buttonLocation.bounds.size.width/2
        buttonMap.clipsToBounds = true
        buttonLocation.clipsToBounds = true
    }
    
    @objc func mapDone()
    {
        AddViewController.selectedAnnotation = selectedAnnotation
        delegate?.backFromMapView()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goCurrentLocation()
    {
        centerViewOnUserLocation()
        
        if let coordinate = locationManager.location?.coordinate {
            removePreviousPin()
            
            addPinToMap(coordinate: coordinate)
            reverseGeocode(coordinate: coordinate)
        }
    }
    
    @objc func changeType_()
    {
        let ac = UIAlertController(title: "Choose Map Style", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: changeType))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: changeType))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: changeType))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlertController))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissAlertController() {
        dismiss(animated: true, completion: nil)
    }
    
    func changeType(action: UIAlertAction)
    {
        guard let actionTitle = action.title else {return}
        
        if let maptype = mapTypes[actionTitle]
        {
            mapView.mapType = maptype
        }
    }
    
    @objc private func handleTap(gestureReconizer: UITapGestureRecognizer) {
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        removePreviousPin()
        
        addPinToMap(coordinate: coordinate)
        reverseGeocode(coordinate: coordinate)
    }
                                         
    private func addPinToMap(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        selectedAnnotation = annotation
    }
    
    private func removePreviousPin() {
        if let existingAnnotation = selectedAnnotation {
            mapView.removeAnnotation(existingAnnotation)
        }
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [self] (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                // Here, you can access the city and country information from the placemark
                self.cityName = placemark.locality
                self.countryName = placemark.country
                AddViewController.countryName = countryName
                AddViewController.cityName = cityName
            }
        }
    }
                                         
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        centerViewOnUserLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }

    private func centerViewOnUserLocation() {
        if let coordinate = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: coordinate,
                                           latitudinalMeters: scale,
                                           longitudinalMeters: scale)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
}
