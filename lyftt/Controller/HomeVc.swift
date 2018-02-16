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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isHidden = true
    destinationField.delegate = self
    currentLocationField.delegate = self
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
        self.tableView.reloadData()
        getUserCurrentLocation()
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == destinationField {
            performSearch()
        }
        self.view.endEditing(true)
        return true
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
    func performSearch() {
        LocationResults.removeAll()
    let searchRequest = MKLocalSearchRequest()
    searchRequest.naturalLanguageQuery = destinationField.text
    searchRequest.region = mapView.region
    let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else if response?.mapItems.count == 0 {
                print("No results found")
            } else {
                for Mapitems in response!.mapItems {
                    self.LocationResults.append(Mapitems as MKMapItem)
                    self.tableView.reloadData()
                }
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
