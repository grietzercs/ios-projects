

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UINavigationControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    
    //class instance variables
    var peerID: MCPeerID! //uniquely identifies users within sessions
    var mcSession: MCSession! //handles all multipeer connectivity
    var mcAdvertiserAssistant: MCAdvertiserAssistant! //session and invitation management
    var mcBrowser: MCBrowserViewController!
    
    var advertiser: MCNearbyServiceAdvertiser!
    //var newBrowser: MCNearbyService
    
    @IBOutlet weak var modeSelection: UISegmentedControl!
    
    var singlePlayer = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.mcSession = MCSession(peer: peerID)
        self.mcBrowser = MCBrowserViewController(serviceType: "testApp", session: mcSession)
        //self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "testApp", discoveryInfo: nil, session: mcSession)
        
        self.advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "testApp")
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        //mcAdvertiserAssistant.start()
        mcSession.delegate = self
        mcBrowser.delegate = self
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        let ac = UIAlertController(title: "Connection Request", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
            invitationHandler(true, self?.mcSession)
        }))
        ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
            invitationHandler(false, nil)
        }))
        present(ac, animated: true)
        //invitationHandler(true, mcSession)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Default")
        }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MultiQuiz {
            destination.mcSession = self.mcSession
            destination.peerID = self.peerID
            mcSession.delegate = destination
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let recievedMessage = NSKeyedUnarchiver.unarchiveObject(with: data) as? String {
                if recievedMessage == "StartGame" {
                    self.performSegue(withIdentifier: "multiMode", sender: self)
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    @IBAction func connectOthers(_ sender: Any) {
        present(mcBrowser, animated: true, completion: nil)
    }
    
    @IBAction func modeSelected(_ sender: Any) {
        if (modeSelection.selectedSegmentIndex == 0) {
            singlePlayer = true
        } else {
            singlePlayer = false
        }
    }
    
    @IBAction func startClicked(_ sender: Any) {
        if ((singlePlayer) && (mcSession.connectedPeers.count <= 0)) {
            performSegue(withIdentifier: "singleMode", sender: self)
        }
        if ((!singlePlayer) && (mcSession.connectedPeers.count < 4)) {
            print("Got this far")
            let data = NSKeyedArchiver.archivedData(withRootObject: "StartGame")
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .unreliable)
            } catch let outputError {
                print("Error: \(outputError)")
            }
            print("Got this far 2")
            
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch let outputError {
                print("Erorr in sending data to peers: \(outputError)")
            }
            
            print("got this far 3")
            performSegue(withIdentifier: "multiMode", sender: self)
        }
    }
    
    
}

