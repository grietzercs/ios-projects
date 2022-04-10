//
//  ViewController.swift
//  MultipeerExample
//
//  Created by Eyuphan Bulut on 4/5/21.
//  Copyright © 2017 Eyuphan Bulut. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var session: MCSession!
    var peerID: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    
    
    @IBOutlet weak var imgView: UIImageView!
    var picker: UIImagePickerController!
    
    @IBOutlet weak var chatWindow: UITextView!
    @IBOutlet weak var messageTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)
        
        assistant.start()
        session.delegate = self
        browser.delegate = self
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        let msg = messageTF.text
        
        
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg!)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        
        updateChatView(newText: msg!, id: peerID)
        
    }
    
    func updateChatView(newText: String, id: MCPeerID){
        
        let currentText = chatWindow.text
        var addThisText = ""
        
        if(id == peerID){
            addThisText = "Me: " + newText + "\n"
        }
        else
        {
            addThisText = "\(id.displayName): \(newText)\n"
        }
        chatWindow.text = currentText! + addThisText
        
    }
    
    @IBAction func connect(_ sender: UIButton) {
        
        present(browser, animated: true, completion: nil)
        
    }
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
     //**********************************************************
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("inside didReceiveData")
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            
            
        if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
            self.updateChatView(newText: receivedString, id: peerID)
        }
            
            
            
        if let image = UIImage(data: data) {
                
            self.imgView.image = image
                
            self.updateChatView(newText: "received image", id: peerID)
                
            //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                
            }
        
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        DispatchQueue.main.async(execute: {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Deafult")
        }
        })
        
    }
    //**********************************************************

    @IBAction func sendImage(){
        picker = UIImagePickerController()
        picker.delegate  = self
        
        present(picker, animated: true, completion: nil)
        
        
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey: Any]) {
        
        let chosenImage = info[.originalImage] as! UIImage
        
        if let imageData = chosenImage.pngData() {
            do {
                try session.send(imageData, toPeers: session.connectedPeers, with: .reliable)
                
                updateChatView(newText: "sending image", id: peerID)
                
            } catch let error as NSError {
                let ac = UIAlertController(title: "Sending image error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true, completion: nil)
            }
        }
    }


}

