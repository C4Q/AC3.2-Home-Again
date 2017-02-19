//
//  HomeAgainViewController.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class HomeAgainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CellTitled {

    // MARK: - Properties
    let titleForCell = "Home Again"
    let cellIdentifier: String = "HomeCellIdentifier"

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.rowHeight = 250.0
        
        self.tableView.register(HomeAgainTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationItem.title = titleForCell
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup View Hierarchy & Constraints
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        navigationController?.navigationBar.backgroundColor = ColorPalette.darkestBlue
        navigationController?.navigationBar.barTintColor = ColorPalette.darkestBlue
        self.view.backgroundColor = ColorPalette.darkBlue
        
        view.addSubview(tableView)
        view.addSubview(crisisView)
        crisisView.addSubview(crisisLabel)
    }
    
    func configureConstraints() {
        
        tableView.snp.makeConstraints { (make) in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        
        crisisView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(100.0)
        }
        
        crisisLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(crisisView)
            make.leading.equalTo(crisisView).offset(16.0)
        }
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return Resource.numberOfResourceSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeAgainTableViewCell
        
        switch indexPath.section {
        case 0:
//            cell.sectionImage.image = #imageLiteral(resourceName: "woofmeow")
            cell.sectionLabel.text = "Drop-In Shelters"
        case 1:
//            cell.sectionImage.image = #imageLiteral(resourceName: "nature")
            cell.sectionLabel.text = "Food Stamps"
        case 2:
//            cell.sectionImage.image =
            cell.sectionLabel.text = "Job Centers"
        default:
            cell.sectionLabel.text = "Libraries"
        }
        cell.backgroundColor = .black

        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.titleForCell = Resource.sections[indexPath.section]
        detailVC.resource = Resource(rawValue: Resource.sections[indexPath.section])!
        detailVC.endpoint = Resource.getEndPoint(Resource.sections[indexPath.section])
        
        navigationController?.pushViewController(detailVC, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = "HOME"
        navigationItem.backBarButtonItem = backItem
    }

    // MARK: - Lazy Instantiate
    lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    lazy var crisisView: UIView = {
        let view = UIView()
        let darkRed = UIColor(red: 158/255, green: 9/255, blue: 28/255, alpha: 1.0)
        view.backgroundColor = darkRed
        view.layer.cornerRadius = 10.0
        return view
    }()
    
    lazy var crisisLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        
        let myAttribute = [ NSFontAttributeName: UIFont.systemFont(ofSize: 18.0),
                            NSForegroundColorAttributeName: UIColor.gray]
        
        let myString = NSMutableAttributedString(string: "In CRISIS?\nPress Button to talk\nto a counselor now.", attributes: myAttribute )
        
        var buttonRange = (myString.string as NSString).range(of: "CRISIS?")
        myString.addAttribute(NSFontAttributeName, value: UIFont.italicSystemFont(ofSize: 18.0), range: buttonRange)
        
        buttonRange = (myString.string as NSString).range(of: "Press Button")
        myString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: buttonRange)
        
        label.attributedText = myString
        
        return label
    }()

}
