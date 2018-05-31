//
//  PeerToPeerManager.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/5/22.
//  Copyright © 2018年 Zhaorui Liu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/// Protocol for dealing with data and updating peers' information
protocol PeerToPeerManagerDelegate: AnyObject {
    /**
     Deal with the data sent by peers
     
     - Parameter manager: The object who manage PeerToPeer network
     - Parameter data: The data sent by peers
     */
    func manager(_ manager: PeerToPeerManager, didReceive data: Data)
    
    /**
     Update how many peers in the P2P network and their information
     
     - Parameter manager: The object who manage PeerToPeer network
     */
    func updatePeers(_ manager: PeerToPeerManager)
}

/// The object who manage PeerToPeer network
class PeerToPeerManager: NSObject {
    /// Indicate the type of service
    static let serviceType = "todo-list"
    
    /// Specify the delegate
    var delegate: PeerToPeerManagerDelegate?
    
    /// Identity in the P2P service
    let peerId = MCPeerID(displayName: "Zhaorui Liu")
    /// To Publish an advertisement for a specific service that your app provides through the Multipeer Connectivity framework and notifies its delegate about invitations from nearby peers.
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    /// To Search (by service type) for services offered by nearby devices
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
    
    /// Enable and manage communication among all peers
    lazy var session: MCSession = {
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    /**
     Invite a particular peer in an interval
     
     - Parameter peer: The peer who is going to be invited
     - Parameter t: time interval
     */
    func invite(peer: MCPeerID, timeout t: TimeInterval = 100) {
        print("Inviting \(peer)")
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
    }
    
    /**
     Send data to a group of peers
     
     - Parameter data: The data need to be sent
     - Parameter toPeers: The array of peers
     */
    func send(data: Data, toPeers: [MCPeerID]) {
        guard !toPeers.isEmpty else { return }
        do {
            try session.send(data, toPeers: toPeers, with: .reliable)
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
            delegate?.updatePeers(self)
        case 1:
            print("SessionDidChange 'connecting'")
        default:
            print("SessionDidChange 'connected'")
            delegate?.updatePeers(self)
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
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}

extension PeerToPeerManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if peerID.displayName == self.peerId.displayName {
            return
        }
        print("Found \(peerID.displayName)")
        invite(peer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost \(peerID)")
    }
}
