//
//  Upco
//  UpcomingEventViewController.swift
//  In Yerevan
//
//  Created by Davit Ghushchyan on 12/16/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit

class UpcomingEventViewController: UIViewController {
    static let id = "UpcomingEventViewController"
    @IBOutlet weak var tableView: UITableView!
    
    var category: Category!
    private var timeGroup = ["today", "thisWeek", "thisMonth"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Main"
        
        // TODO: - if admin permissions => 
        if User.isAdministration {
            timeGroup.insert("New event", at: 0)
        }
        // timeGroup = FetchCategories
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
}


extension UpcomingEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = tableView.bounds.height / 3
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.id, for: indexPath) as! UpcomingTableViewCell
        cell.prepareCellWith(label: timeGroup[indexPath.row], background: #imageLiteral(resourceName: "Activity"))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeGroup.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        func goToEventsVCWith(events: [Event]) {
            let vc = storyboard?.instantiateViewController(withIdentifier: EventsViewController.id) as! EventsViewController
            vc.events = events
            navigationController?.pushViewController(vc, animated: true)
        }
        
        // if admin permissions => 
        if User.isAdministration {
            switch indexPath.row {
            case 0 : 
                let vc = storyboard?.instantiateViewController(withIdentifier: NewEventViewController.id)
                navigationController?.pushViewController(vc!, animated: true)
                
            case 1:
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfDay, for: category))
            case 2:
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfWeek, for: category))
            default: 
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfMonth(), for: category))
            }
            
        }  else {
            switch indexPath.row {
            case 0 : 
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfDay, for: category))
                
            case 1:
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfWeek, for: category))
            default: 
                goToEventsVCWith(events: UIApplication.dataManager.fetchAllEventsFromNowTill(date: Date().endOfMonth(), for: category))
                
            }
            
        }
        
        
    }
}
