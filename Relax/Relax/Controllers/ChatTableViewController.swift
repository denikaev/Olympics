//
//  ChatTableViewController.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {
    
    // MARK: Properties
    let NO_PHOTO_DEFAULT = "https://vk.com/images/camera_50.png"        // default photo on vk.com
    var photos = [Int: UIImage?]() {
        didSet {
            DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
        }
    }
    var friends = [Friend]() {
        didSet {
            for friend in friends {
                if let _ = photos[friend.user_id] {
                    // #TODO =)
                } else {
                    if friend.photo != NO_PHOTO_DEFAULT {
                        print("[ChatTableViewController.friends.didSet] load photo=\(friend.photo)")            // #DEBUG
                        getPhotoOnline(forUserID: friend.user_id, photoURL: friend.photo)
                    } else {
                        print("[ChatTableViewController.friends.didSet] set photo=nil")                         // #DEBUG
                        photos.updateValue(nil, forKey: friend.user_id)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataManager.shared.isUserAutorized() {
            getFriendsFromVK()
        }
    }
    
    // Get user friends info from vk.com
    func getFriendsFromVK() {
        VKClient().getFriends { [weak self] friendList in
            print("[ChatTableVC.getFriendsFromVK] Loaded \(friendList.count) friends from vk.com")      // #DEBUG
            self?.friends = friendList
        }
    }
    
    // Load users photo to cache
    func getPhotoOnline(forUserID id: Int, photoURL urlStr: String) {
        Utils().getImageOnline(imageURLString: urlStr) { [weak self] photo in
            DispatchQueue.main.async {
                print("[ChatTableVC.getPhotoOnline] Loaded photo for id=\(String(id)) from vk.com")      // #DEBUG
                self?.photos.updateValue(photo, forKey: id)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath)

        // Configure the cell...
        let userID = friends[indexPath.row].user_id
        
        // User photo
        if let ph = photos[userID], let photo = ph {
            cell.imageView?.image = photo
            print("[Configure the cell...]  set photo to userID=\(userID)")             // #DEBUG
        } else {
            cell.imageView?.image = #imageLiteral(resourceName: "NoPhoto")
            print("[Configure the cell...]  set DEFAULT photo to userID=\(userID)")     // #DEBUG
        }
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = cell.bounds.height / 4

        // User name
        cell.textLabel?.text = "\(friends[indexPath.row].first_name) \(friends[indexPath.row].last_name)"
        
        // User status
        if friends[indexPath.row].online {
            cell.detailTextLabel?.text = "online"
            cell.detailTextLabel?.textColor = .blue
        } else {
            cell.detailTextLabel?.text = "offline"
            cell.detailTextLabel?.textColor = .black
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let dvc = segue.destination as! ChatController
            dvc.friend = friends[indexPath.row]
        }

        // Set back button in navigation bar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
}
