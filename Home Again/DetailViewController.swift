//
//  DetailViewController.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit
import CoreLocation
import SnapKit
import GoogleMaps
import GooglePlaces

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellTitled {
    
    var distance = [Distance]()
    
    // MARK: - Properties
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    private var zoomLevel: Float = 15.0
    private var currentPositionMarker = GMSMarker()
    
    var titleForCell: String = ""
    var resource: Resource = .undeclared
    var endpoint: String = Resource.undeclared.rawValue
    let cellIdentifier = "DetailCell"
    
    var shelters = [DropInCenter]()
    var foodstamps = [FoodStamp]()
    var jobcenters = [JobCenter]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // API Call
        getData()
        // Google Maps Setup
        setupMaps()
        // get Distance
        apicall()
        
        setupViewHierarchy()
        configureConstraints()

        placesClient = GMSPlacesClient.shared()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        self.navigationController?.navigationBar.tintColor = ColorPalette.textIconColor
        self.title = titleForCell
        
        view.addSubview(mapView)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    func configureConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - API Call
    func getData() {
        APIRequestManager.manager.getData(endPoint: endpoint) { (data) in
            
            guard let data = data else { return }
            
            switch self.resource {
            case .shelter:
                self.shelters = DropInCenter.getDropInCenters(from: data)
            case .foodstamp:
                self.foodstamps = FoodStamp.getFoodStamps(from: data)
            default:
                self.jobcenters = JobCenter.getJobCenters(from: data)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Setup Google Map
    func setupMaps() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 40.742362,
                                              longitude: -73.935365,
                                              zoom: 18)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.map = mapView
    }
    
    func updateCurrentPositionMarker(currentLocation: CLLocation) {
        self.currentPositionMarker.map = nil
        self.currentPositionMarker = GMSMarker(position: currentLocation.coordinate)
        self.currentPositionMarker.icon = GMSMarker.markerImage(with: UIColor.cyan)
        self.currentPositionMarker.map = self.mapView
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let borough = Resource.boroughs[section]
        
        switch resource {
        case .shelter:
            return shelters.filter { $0.borough == borough }.count
        case .foodstamp:
            return foodstamps.filter { $0.borough == borough }.count
        default:
            return jobcenters.filter { $0.borough == borough }.count
        }
        
    }
    //MARK: - DISTANCE
    
    func apicall() {
        
        print("helllo")
        let there = "2402 Atlantic Ave, Brooklyn, NY"
        let here = "31-00 47th Ave, Long Island City, NY"
        let googleGeoAPIEndPoint = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(here)&destinations=\(there)&key=AIzaSyDzelqdk1T1ZFytQavZwrpSTYw6pvZDTek"
        let myEndpoint = googleGeoAPIEndPoint.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        APIRequestManager.manager.getData(endPoint: myEndpoint!) { (data) in
            if let validData = data,
                let theDistance = Distance.getDistance(data: validData) {
                self.distance = theDistance
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailTableViewCell
        
    
        switch resource {
        case .shelter:
            
            switch indexPath.section {
            case 0:
                cell.facilityName.text = shelters.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityName
                cell.facilityAddress.text = shelters.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityAddress
            case 1:
                cell.facilityName.text = shelters.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityName
                cell.facilityAddress.text = shelters.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityAddress
            case 2:
                cell.facilityName.text = shelters.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityName
                cell.facilityAddress.text = shelters.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityAddress
            case 3:
                cell.facilityName.text = shelters.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityName
                cell.facilityAddress.text = shelters.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityAddress
            default:
                cell.facilityName.text = shelters.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityName
                cell.facilityAddress.text = shelters.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityAddress
            }
            
        case .foodstamp:
            
            switch indexPath.section {
            case 0:
                cell.facilityName.text = foodstamps.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityName
                cell.facilityAddress.text = foodstamps.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityAddress
            case 1:
                cell.facilityName.text = foodstamps.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityName
                cell.facilityAddress.text = foodstamps.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityAddress
            case 2:
                cell.facilityName.text = foodstamps.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityName
                cell.facilityAddress.text = foodstamps.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityAddress
            case 3:
                cell.facilityName.text = foodstamps.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityName
                cell.facilityAddress.text = foodstamps.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityAddress
            default:
                cell.facilityName.text = foodstamps.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityName
                cell.facilityAddress.text = foodstamps.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityAddress
            }

        default:
            
            switch indexPath.section {
            case 0:
                cell.facilityName.text = jobcenters.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityName
                cell.facilityAddress.text = jobcenters.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityAddress
            case 1:
                cell.facilityName.text = jobcenters.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityName
                cell.facilityAddress.text = jobcenters.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityAddress
            case 2:
                cell.facilityName.text = jobcenters.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityName
                cell.facilityAddress.text = jobcenters.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityAddress
            case 3:
                cell.facilityName.text = jobcenters.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityName
                cell.facilityAddress.text = jobcenters.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityAddress
            default:
                cell.facilityName.text = jobcenters.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityName
                cell.facilityAddress.text = jobcenters.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityAddress
            }

        }
        
        cell.contentView.backgroundColor = ColorPalette.lightestBlue
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 90))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 2.0
        whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Resource.boroughs[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - Lazy Instantiate
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorPalette.lightBlue
        table.alpha = 1.0
        table.estimatedRowHeight = 200.0
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()

}

// MARK: - Delegates to handle events for the location manager.
extension DetailViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location)
            // 7
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            // 8
            if let test = mapView.myLocation {
            updateCurrentPositionMarker(currentLocation: test)
            locationManager.stopUpdatingLocation()
            }
            
        }
        
//        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
//                                              longitude: location.coordinate.longitude,
//                                              zoom: zoomLevel)
        
//        if (self.view as! GMSMapView).isHidden {
//            
//        }
        
//        if mapView.isHidden {
//            mapView.isHidden = false
//            mapView.camera = camera
//        } else {
//            mapView.animate(to: camera)
//        }
//        
//        listLikelyPlaces()
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
}

