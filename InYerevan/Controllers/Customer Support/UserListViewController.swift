//
//  UserListViewController.swift
//  In Yerevan
//
//  Created by Vahram Tadevosian on 12/25/18.
//  Copyright © 2018 com.inYerevan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MessageKit

final class UserListViewController: UITableViewController {
    
    // MARK:- FIREBASE PROPERTIES
    
    private let db = Firestore.firestore()
    private let channelCellIdentifier = "channelCell"
    private var channels = [Channel]()
    private var channelListener: ListenerRegistration?
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    
    // MARK:- VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        listenToChanges()
        tableView.register(UINib(nibName: ChannelCell.id, bundle: nil),
                           forCellReuseIdentifier: ChannelCell.id)
        let view = UIView(frame: tableView.bounds)
        view.changeBackgroundToGradient(from: [.backgroundDarkSpruce, .backgroundDenimBlue])
        tableView.backgroundColor = .clear
        tableView.backgroundView = view
        tableView.tableFooterView = UIView(frame: .zero)

    }
    
    deinit {
        channelListener?.remove()
    }
    
    // MARK:- ACTIONS
    
    private func createChannel(_ channel: Channel) {
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let channel = Channel(document: change.document) else { return }
        switch change.type {
        case .added:
            addChannelToTable(channel)
        case .modified:
            updateChannelInTable(channel)
        case .removed:
            removeChannelFromTable(channel)
        }
    }
    
    // MARK :- HELPER FUNCTIONS
    
    private func listenToChanges() {
        channelListener = channelReference.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func addChannelToTable(_ channel: Channel) {
        guard !channels.contains(channel) else {
            return
        }
        channels.append(channel)
        channels.sort()
        guard let index = channels.index(of: channel) else { return }
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func updateChannelInTable(_ channel: Channel) {
        guard let index = channels.index(of: channel) else { return }
        channels[index] = channel
        channels.sort()
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    private func removeChannelFromTable(_ channel: Channel) {
        guard let index = channels.index(of: channel) else { return }
        channels.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
}

// MARK:- TABLE VIEW DATA SOURCE
extension UserListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChannelCell.id, for: indexPath) as! ChannelCell
        cell.channel = channels[indexPath.row]
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
}

// MARK:- TABLE VIEW DELEGATE
extension UserListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chatvc") as! ChatViewController
        vc.channel = channels[indexPath.row]
        vc.title = vc.channel.name
        navigationController?.pushViewController(vc, animated: true)
    }
}
