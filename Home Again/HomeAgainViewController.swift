//
//  HomeAgainViewController.swift
//  Home Again
//
//  Created by Eric Chang on 2/17/17.
//  Copyright © 2017 Eric Chang. All rights reserved.
//

import UIKit

class HomeAgainViewController: UITableViewController, CellTitled {

    // MARK: - Properties
    let titleForCell = "Home Again"
    let cellIdentifier: String = "HomeCellIdentifier"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        self.tableView.rowHeight = 250.0
        
        self.tableView.register(HomeAgainTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationItem.title = titleForCell
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViewHierarchy() {
        self.edgesForExtendedLayout = []
        
        navigationController?.navigationBar.backgroundColor = ColorPalette.darkestBlue
        navigationController?.navigationBar.barTintColor = ColorPalette.darkestBlue
        self.view.backgroundColor = ColorPalette.darkBlue
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Resource.numberOfResourceSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
//        cell.newLabel.font = UIFont(name: "Optima-Bold", size: 24.0)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.titleForCell = Resource.sections[indexPath.section]
        detailVC.resource = Resource(rawValue: Resource.sections[indexPath.section])!
        detailVC.endpoint = Resource.getEndPoint(Resource.sections[indexPath.section])
        
        navigationController?.pushViewController(detailVC, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = "HOME"
        navigationItem.backBarButtonItem = backItem
    }


}
