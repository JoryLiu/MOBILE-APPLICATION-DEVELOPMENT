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
    func updatePeers(_ manager: PeerToPeerManager)
}

class PeerToPeerManager: NSObject {
    static let serviceType = "todo-list"
    
    var delegate: PeerToPeerManagerDelegate?
    var waitingList = [String]()
    
    let peerId = MCPeerID(displayName: "Zhaorui Liu")
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
        let session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        return session
    }()
    
    func invite(peer: MCPeerID, timeout t: TimeInterval = 100) {
        print("Inviting \(peer)")
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: t)
    }
    
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
        delegate?.updatePeers(self)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost \(peerID)")
    }
}
