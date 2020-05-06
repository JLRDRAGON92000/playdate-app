//
//  MyEventsViewController.swift
//  playdate-app
//
//  Created by Jared Rankin on 2020-03-03.
//  Copyright © 2020 Jared Rankin. All rights reserved.
//

import UIKit
import Firebase

protocol LogIn {
    func signedIn(withDisplayName: String?)
}

class MyEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, LogIn {
    
    @IBOutlet weak var myEventsVCNotSignedIn: UIView!
    @IBOutlet weak var myEventsVCSignedIn: UITableView!
    
    private let eventDetailSegueId = "meToEventDetail"
    private let loginSegueId = "LogInIdentifier"
    private let settingsSegueId = "SettingsIdentifier"
    private let signUpSegueId = "SignUpIdentifier"
    private var userEmail = ""
    private var displayName = ""
    
    private var dataSource: EventDataSource!
    
    private var loggedIn = false
    private var myEvents: [EventDataType] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = AppDelegate.instance.dataSource
        
        Auth.auth().addStateDidChangeListener { auth, user in
            self.loggedIn = (user != nil)
            
            self.myEventsVCNotSignedIn.isHidden = self.loggedIn
            self.myEventsVCSignedIn.isHidden = !self.loggedIn
            if user != nil {
                self.userEmail = (user?.email)!
                self.displayName = user?.displayName ?? ""
                
                // load favourite events if we're logged in
                self.dataSource.starredEvents { events in
                    self.myEvents = events
                    self.myEventsVCSignedIn.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loggedIn {
            dataSource.starredEvents { events in
                self.myEvents = events
                self.myEventsVCSignedIn.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myEvents.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventData = myEvents[indexPath.row]
        
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        if let cell = reusableCell as? EventTableViewCell {
            cell.index = indexPath.row
            cell.eventId = eventData.id
            cell.eventImageView.image = UIImage(named: eventData.imageId)
            cell.eventTitleLabel.text = eventData.title
            cell.eventVenueLabel.text = eventData.venueName
            cell.eventDatesLabel.text = eventData.startDateTimeDescription
            return cell
        } else {
            return reusableCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == eventDetailSegueId,
            let dest = segue.destination as? EventDetailViewController,
            let cell = sender as? EventTableViewCell {

            dest.event = myEvents[cell.index]
        } else if segue.identifier == loginSegueId {
            let destination = segue.destination as! LoginViewController
            destination.delegate = self
        } else if segue.identifier == settingsSegueId {
            let destination = segue.destination as! SettingsViewController
            destination.delegate = self
            destination.signedIn = loggedIn
            destination.userEmail = self.userEmail
            destination.displayName = self.displayName
        } else if segue.identifier == signUpSegueId {
            let destination = segue.destination as! SignUpViewController
            destination.delegate = self
        }
    }
    
    // called by login controller to notify us that the user has logged in,
    // optionally with a specified display name (for new accounts)
    func signedIn(withDisplayName displayName: String?) {
        loggedIn = true
        myEventsVCNotSignedIn.isHidden = true
        myEventsVCSignedIn.isHidden = false
        
        if let name = displayName {
            self.displayName = name
        }
    }
}
