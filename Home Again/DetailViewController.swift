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


class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CellTitled{
    
    
    
    
   
    
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
    var animator: UIViewPropertyAnimator?
    
    var resources = [ResourcesTable]()
    
    
    
   
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // API Call
        getData()
        // Google Maps Setup
        setupMaps()
        
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
        
        self.navigationController?.navigationBar.tintColor = ColorPalette.lightestBlue
        self.title = titleForCell
        
        view.addSubview(mapView)
        view.addSubview(tableView)
        view.addSubview(backToTable)
        view.addSubview(applyNowView)
        applyNowView.addSubview(applyButton)
        backToTable.addSubview(backToImage)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        animator = UIViewPropertyAnimator(duration: 2.0, dampingRatio: 0.75, animations: nil)
        
        backToTable.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bringBackTable)))
        backToImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bringBackTable)))
        
        
        applyButton.addTarget(self, action: #selector(applyNowTapped), for: .touchUpInside)
        
    }
    
    func configureConstraints() {
        
        mapView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.0)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(1.0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        backToTable.snp.makeConstraints { (make) in
            make.height.width.equalTo(50.0)
            make.leading.bottom.equalToSuperview().inset(16.0)
        }
        
        backToImage.snp.makeConstraints { (make) in
            make.height.width.equalTo(backToTable).multipliedBy(0.5)
            make.center.equalTo(backToTable)
        }
        
        
        applyNowView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(80.0)
        }
        
        applyButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(applyNowView)
            make.centerX.equalTo(applyNowView)

            make.height.equalTo(applyNowView).multipliedBy(0.5)
            make.width.equalTo(applyNowView).multipliedBy(0.5)
        }
        
        
    }
    
    // MARK: - API Call
    func getData() {
        APIRequestManager.manager.getData(endPoint: endpoint) { (data) in
            guard let data = data else { return }
            self.resources = []
            
            switch self.resource {
            case .shelter:
                self.resources = DropInCenter.getDropInCenters(from: data)
            case .foodstamp:
                self.resources = FoodStamp.getFoodStamps(from: data)
                self.applyNowView.isHidden = false
                self.applyButton.isHidden = false
            case .jobs:
                self.resources = JobCenter.getJobCenters(from: data)
            default:
                self.resources = Library.getLibraries(from: data)
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
        
    }
    
    func updateCurrentPositionMarker(currentLocation: CLLocation) {
        currentPositionMarker.map = nil
        currentPositionMarker = GMSMarker(position: currentLocation.coordinate)
        currentPositionMarker.icon = GMSMarker.markerImage(with: .purple)
        currentPositionMarker.appearAnimation = .pop
        currentPositionMarker.snippet = "You are here"
        currentPositionMarker.map = self.mapView
    }
    
    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let borough = Resource.boroughs[section]
        
        return resources.filter { $0.borough == borough }.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailTableViewCell
        
        //TODO: - DISTANCE
        switch indexPath.section {
        case 0:
            cell.facilityName.text = resources.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityName
            cell.facilityAddress.text = resources.filter { $0.borough == Resource.boroughs[0] }[indexPath.row].facilityAddress
        case 1:
            cell.facilityName.text = resources.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityName
            cell.facilityAddress.text = resources.filter { $0.borough == Resource.boroughs[1] }[indexPath.row].facilityAddress
        case 2:
            cell.facilityName.text = resources.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityName
            cell.facilityAddress.text = resources.filter { $0.borough == Resource.boroughs[2] }[indexPath.row].facilityAddress
        case 3:
            cell.facilityName.text = resources.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityName
            cell.facilityAddress.text = resources.filter { $0.borough == Resource.boroughs[3] }[indexPath.row].facilityAddress
        default:
            cell.facilityName.text = resources.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityName
            cell.facilityAddress.text = resources.filter { $0.borough == Resource.boroughs[4] }[indexPath.row].facilityAddress
        }
        
        cell.contentView.backgroundColor = ColorPalette.darkBlue
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 8, width: self.view.frame.size.width - 20, height: 85))
        
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
        let cell = tableView.cellForRow(at: indexPath) as! DetailTableViewCell
        
        // Animate Map
        animator?.addAnimations ({
            self.backToTable.alpha = 1.0
        })
        
        animator?.addAnimations ({
            self.tableView.snp.remakeConstraints({ (make) in
                make.top.lessThanOrEqualTo(self.view.snp.bottom)
                make.height.width.centerX.equalToSuperview()
            })
            
            self.mapView.snp.remakeConstraints({ (make) in
                make.leading.top.trailing.bottom.equalToSuperview()
            })
            
            if let address = cell.facilityAddress.text {
                self.title = address
            }
            
            self.view.layoutIfNeeded()
        })
        animator?.startAnimation()
        
        // Pin markers on selected facility
        var address = ""
        
        if let characters = cell.facilityAddress.text {
            for i in characters.characters {
                if i == "," { break }
                address.append(i)
            }
        }
        guard let ad = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        APIRequestManager.manager.getData(endPoint: "https://api.cityofnewyork.us/geoclient/v1/search.json?app_id=9f38ae63&app_key=cd84b648110b8ee65df34f449aee7c1e&input=\(ad)") { (data) in
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let jsonArray = jsonData as? [String: Any],
                    let results = jsonArray["results"] as? [[String: Any]],
                    let response = results[0]["response"] as? [String: Any] {
                    
                    guard let latitude = response["latitude"] as? Double,
                        let longitude = response["longitude"] as? Double else { return }
                    
                    DispatchQueue.main.async {
                        self.mapView.camera = GMSCameraPosition.camera(withLatitude: latitude,
                                                                       longitude: longitude,
                                                                       zoom: 18)
                        
                        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        let marker = GMSMarker(position: position)
                        marker.appearAnimation = .pop
                        marker.icon = GMSMarker.markerImage(with: .cyan)
                        if let name = cell.facilityName.text {
                            marker.title = name
                        }
                        marker.map = self.mapView
                    }
                }
            }
            catch {
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    func bringBackTable() {
        animator?.addAnimations ({
            self.backToTable.alpha = 0.0
        })
        
        animator?.addAnimations ({
            self.mapView.snp.remakeConstraints { (make) in
                make.leading.top.trailing.equalToSuperview()
                make.height.equalToSuperview().multipliedBy(0.0)
            }
            
            self.tableView.snp.remakeConstraints { (make) in
                make.height.equalToSuperview().multipliedBy(1.0)
                make.leading.trailing.bottom.equalToSuperview()
            }
            self.title = self.titleForCell
            self.view.layoutIfNeeded()
        })
        animator?.startAnimation()
        
    }
    
    func applyNowTapped() {
        
        navigationController?.pushViewController(WebViewController(), animated: true)
    }
    
    
    
    // MARK: - Lazy Instantiate
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = ColorPalette.darkBlue
        table.alpha = 1.0
        table.estimatedRowHeight = 200.0
        table.rowHeight = UITableViewAutomaticDimension
        return table
    }()
    
    lazy var backToTable: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25.0
        view.layer.masksToBounds = true
        view.alpha = 0.0
        view.backgroundColor = ColorPalette.lightestBlue
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var backToImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Double Up-64")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    lazy var applyNowView: UIView = {
        let view = UIView()
        let darkRed = ColorPalette.darkestBlue
        view.backgroundColor = darkRed
        view.layer.cornerRadius = 10.0
        view.isHidden = true
        return view
    }()
    
    
    lazy var applyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 7.0
        
        let darkRed = UIColor(red: 158/255, green: 9/255, blue: 28/255, alpha: 1.0)
        
        let myAttribute = [ NSForegroundColorAttributeName: darkRed ]
        let myString = NSMutableAttributedString(string: "APPLY ONLINE", attributes: myAttribute)
        
        var buttonRange = (myString.string as NSString).range(of: "")
        myString.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 18.0), range: buttonRange)
        
        button.setAttributedTitle(myString, for: .normal)
        button.isHidden = true
        return button
    }()
    
    
}

// MARK: - Delegates to handle events for the location manager.
extension DetailViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            updateCurrentPositionMarker(currentLocation: location)
            locationManager.stopUpdatingLocation()
        }
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
