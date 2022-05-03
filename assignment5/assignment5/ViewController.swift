//
//  ViewController.swift
//  assignment5
//
//  Created by Colden on 5/3/22.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    //class instance variables
    var peerID: MCPeerID! //uniquely identifies users within sessions
    var mcSession: MCSession! //handles all multipeer connectivity
    var mcAdvertiserAssistant: MCAdvertiserAssistant! //session and invitation management
    var mcBrowser: MCBrowserViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
        mcBrowser = MCBrowserViewController(serviceType: "testApp", session: mcSession)
        mcBrowser.delegate = self
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected: print ("connected \(peerID)")
            case .connecting: print ("connecting \(peerID)")
            case .notConnected: print ("not connected \(peerID)")
            default: print("unknown status for \(peerID)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Host a session", style: .default) { (UIAlertAction) in
            self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "testApp", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
        })
        
        ac.addAction(UIAlertAction(title: "Join a session", style: .default) { (UIAlertAction) in
//            self.mcBrowser = MCBrowserViewController(serviceType: "testApp", session: self.mcSession)
//            self.mcBrowser.delegate = self
            self.present(self.mcBrowser, animated: true, completion: nil)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
}

