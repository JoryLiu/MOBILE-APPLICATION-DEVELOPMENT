//
//  PeerToPeerManager.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/5/22.
//  Copyright © 2018年 Zhaorui Liu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol PeerToPeerManagerDelegate: AnyObject {
    func manager(_ manager: PeerToPeerManager, didReceive data: Data)
}

class PeerToPeerManager: NSObject {
    static let serviceType = "todo-list"
    
    var delegate: PeerToPeerManagerDelegate?
    
    private let peerId = MCPeerID(displayName: "Zhaorui")
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    
    override init() {
        let service = PeerToPeerManager.serviceType
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: [peerId.displayName: UIDevice.current.name], serviceType: service)
        serviceBrowser = MCNearbyServiceBrowser(peer: peerId, serviceType: service)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    lazy var session: MCSession = {
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 10) {
        print("Inviting \(peer)")
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
    }
    
    func send(data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error '\(error)' sending \(data.count) bytes of data")
        }
        
    }
}

extension PeerToPeerManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("Received invitation from \(peerId)")
        invitationHandler(true, session)
    }
}

extension PeerToPeerManager: MCSessionDelegate {
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Received \(data.count) bytes")
        delegate?.manager(self, didReceive: data)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state.rawValue {
        case 0:
            print("SessionDidChange 'notConnected'")
        case 1:
            print("SessionDidChange 'connecting'")
        default:
            print("SessionDidChange 'connected'")
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("ReceiveStream \(streamName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("ReceiveResource \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Finished receiving resource \(resourceName)")
    }
}

extension PeerToPeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if peerID.displayName == self.peerId.displayName {
            return
        }
        print("Found \(peerID.displayName)")
        let notificationName = Notification.Name(rawValue: "Found Peer")
        NotificationCenter.default.post(name: notificationName, object: self, userInfo: ["peerID": peerID])
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "Invite Peer"), object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo,
                let collaborator = userInfo["peerID"] as? MCPeerID else {
                    return
            }
            self.invite(peer: collaborator)
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost \(peerID)")
    }
}
