//
//  EventsHomeViewController.swift
//  playdate-app
//
//  Created by Jared Rankin on 2020-03-18.
//  Copyright © 2020 Jared Rankin. All rights reserved.
//

import UIKit
import CoreData

class EventsHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let eventDetailSegueId = "homeToEventDetail"
    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource: EventDataSource!
    private var events: [EventDataType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = AppDelegate.instance.dataSource
        fetchSettings()
        
        dataSource.homePageEvents { events in
            self.events = events
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventData = events[indexPath.row]
        
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        if let cell = reusableCell as? EventTableViewCell {
            cell.eventId = (eventData["id"] as! String)
            cell.eventImageView.image = UIImage(systemName: eventData["imageId"] as! String)
            cell.eventTitleLabel.text = eventData["title"] as? String
            cell.eventVenueLabel.text = eventData["venue"] as? String
            cell.setDate(eventData["startDate"] as? Date)
            return cell
        } else {
            return reusableCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // so the row doesn't stay selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == eventDetailSegueId,
            let dest = segue.destination as? EventDetailViewController,
            let ip = tableView.indexPathForSelectedRow?.row {

            dest.event = events[ip]
        }
    }
    
    private func describeDate(_ date: Date?) -> String {
        if let date = date {
            let dateFormat = DateFormatter()
            let timeFormat = DateFormatter()
            dateFormat.dateStyle = .medium
            timeFormat.timeStyle = .short
            
            return dateFormat.string(from: date) + ", " + timeFormat.string(from: date)
        } else {
            return ""
        }
    }
    
    func fetchSettings() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Settings")
        var fetchedSettings:[NSManagedObject]? = nil
        
        do {
            try fetchedSettings = context.fetch(request) as? [NSManagedObject]
        } catch {
            // If an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if (fetchedSettings!.count != 0) {
            if (fetchedSettings![0].value(forKeyPath: "isDarkMode") as! Bool) {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
            }
            else {
                UIApplication.shared.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
            }
        }
    }
}

