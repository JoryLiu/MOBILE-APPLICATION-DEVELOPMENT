//
//  PeerToPeerManager.swift
//  GettingThingsDone
//
//  Created by 刘钊睿 on 2018/5/22.
//  Copyright © 2018年 Zhaorui Liu. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class PeerToPeerManager: NSObject {
    static let serviceType = "todo-list"
    
    private let peerId = MCPeerID(displayName: "Zhaorui Liu")
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
    }
    
    deinit {
        serviceAdvertiser.stopAdvertisingPeer()
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
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("SessionDidChange \(state)")
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
        print("Found \(peerID.displayName)")
        invite(peer: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost \(peerID)")
    }
}
