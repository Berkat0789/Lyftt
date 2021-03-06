//
//  HomeVc.swift
//  lyftt
//
//  Created by berkat bhatti on 2/15/18.
//  Copyright © 2018 TKM. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class HomeVc: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
//--Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var destinationField: UITextField!
    @IBOutlet weak var currentLocationField: UITextField!
    
//--var and arrays
    var  locationManager = CLLocationManager()
    var locationAuthStatus = CLLocationManager.authorizationStatus()
    var coordinateRadius: Double = 1000
    var LocationResults: [MKMapItem] = [MKMapItem]()
    var destinationPlacemark: MKPlacemark!
    var route: MKRoute!

    @IBOutlet weak var menuIcon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuIcon.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = true
    mapView.delegate = self
    destinationField.delegate = self
    currentLocationField.delegate = self
        
        DataService.instance.FB_Reference_Drivers.observeSingleEvent(of: .value) { (driverSnapshot) in
            DataService.instance.getDriversAnnotations(completed: { (driversAnnotation) in
                guard let driverSnapshot = driverSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for drivers in driverSnapshot {
                    if drivers.childSnapshot(forPath: "isDrivermodeEnabled").value as! Bool == true {
                        for annotation in self.mapView.annotations {
                            self.mapView.removeAnnotation(annotation)
                        }
                    }
                }
            })
        }//end observe driver
     
        
        
        
    }//--End view did load
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserCurrentLocation()
        AuthorizeLocationService()
    }

//--Protocol functions
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getUserCurrentLocation()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? driverAnnotation {
        let identifier = "driverAnnotation"
        let view : MKAnnotationView
        view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        let image = UIImage(named: "car")
        view.image = image
        return view
        } else if let riderannotation = annotation as? passangerAnnotaiton {
            let identifier = "passanger"
            var view = MKAnnotationView()
            view = MKAnnotationView(annotation: riderannotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "Userpic")
            return view
        } else if let destinationAnnotation = annotation as? destinationAnnotaiton {
            let identifier = "destination"
            var view = MKAnnotationView()
            view = MKAnnotationView(annotation: destinationAnnotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "destinationAnnotation")
            
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdateLocationService.instance.updateDriverLocaton(forCoordinate: userLocation.coordinate) { (Success) in
            //
        }
        UpdateLocationService.instance.updateUserLocation(forCoordinate: userLocation.coordinate) { (Success) in
            //
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocationResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as? LocationCell else {return UITableViewCell()}
        let location = LocationResults[indexPath.row]
        cell.updateCell(locationName: location.name!, LocationAddress: location.placemark.title!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let passangerCoordinate = locationManager.location?.coordinate else {return}
        let passangerAnnotation = passangerAnnotaiton(Coordinate: passangerCoordinate, userID: (Auth.auth().currentUser?.uid)!)
        mapView.addAnnotation(passangerAnnotation)
        let selectedLocation = LocationResults[indexPath.row]
        destinationField.text = selectedLocation.placemark.title
        DataService.instance.FB_Reference_Users.child((Auth.auth().currentUser?.uid)!).updateChildValues(["destination" : [selectedLocation.placemark.coordinate.latitude, selectedLocation.placemark.coordinate.longitude]])
        dropPin(placeMark: selectedLocation.placemark)
        getPolylineForDirectin(forMapitem: selectedLocation)
        self.tableView.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == destinationField {
            self.tableView.isHidden = false
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        LocationResults = []
        tableView.reloadData()
        getUserCurrentLocation()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == destinationField {
            self.view.endEditing(true)
            performSearch()
        }
        return true
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)
        lineRenderer.strokeColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        lineRenderer.lineWidth = 3
        zoom(toFitAnnotationFromMapView: self.mapView)
        return lineRenderer
    }
    func zoom(toFitAnnotationFromMapView mapview: MKMapView) {
        if mapview.annotations.count == 0 {
            return
        }
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        for annotation in mapview.annotations {
            //modify the top and bottom with Fmin and Fmax
            topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        // set region
        var region  = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0))
        region = mapview.regionThatFits(region)
        mapview.setRegion(region, animated: true)
        
    }
    
    
//--Actions
    @IBAction func locationButtonPressed(_ sender: Any) {
        if locationAuthStatus == .authorizedAlways || locationAuthStatus == .authorizedWhenInUse {
            getUserCurrentLocation()
        }else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
//--Selectors
    
//--View Functions
    
    func dropPin(placeMark: MKPlacemark) {
        destinationPlacemark = placeMark
        for annotation in mapView.annotations {
            if annotation.isKind(of: MKPointAnnotation.self) {
                mapView.removeAnnotation(annotation)
            }
        }
        let annotation = destinationAnnotaiton(coordinate: placeMark.coordinate, userID: (Auth.auth().currentUser?.uid)!)
        annotation.coordinate = placeMark.coordinate
        mapView.addAnnotation(annotation)
    }
    func performSearch() {
    LocationResults = []
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = destinationField.text
    searchRequest.region = mapView.region
    let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                for mapitems in response!.mapItems {
                    self.LocationResults.append(mapitems as MKMapItem)
                    self.tableView.reloadData()
                }
            }
        }
    }
    func getPolylineForDirectin(forMapitem mapItem: MKMapItem) {
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = mapItem
        directionRequest.transportType = MKDirectionsTransportType.automobile
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                //-- 0 point gets the st best route
                self.route = response?.routes[0]
                self.mapView.add(self.route.polyline)
            }
        }
    }

func getUserCurrentLocation() {
        guard let userLocation = locationManager.location?.coordinate else{return}
        let LocationCoordinate = MKCoordinateRegionMakeWithDistance(userLocation, coordinateRadius * 2.0, coordinateRadius * 2.0)
        mapView.setRegion(LocationCoordinate, animated: true)
    }
    func AuthorizeLocationService() {
        if locationAuthStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    


}
