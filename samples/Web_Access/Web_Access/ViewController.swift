//
//  ViewController.swift
//  Web_Access
//
//  Created by Eyuphan Bulut on 4/7/22.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {

    @IBOutlet weak var percentLabel: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let session = URLSession.shared
        
    
        
        let defaultSession = URLSession(configuration: .default)
        let ephemeralSession  = URLSession(configuration: .ephemeral)
        
        
        //defaultSession.configuration.allowsCellularAccess = false
        //defaultSession.configuration.networkServiceType = .video
        
        
        let myURL = URL(string: "http://www.people.vcu.edu/~ebulut/sampleFile.txt")
        let urlString = "http://api.openweathermap.org/data/2.5/find?q=NewYork&appid=881143b83f8b900d864067c69c4d96fe"
        let url = URL(string: urlString)
        
        let notURL = URL(string: "https://people.vcu.edu/~ebulut/abc.html")
        
        let task = session.dataTask(with: notURL!){
            (data, response, error) in
                
                print(data)
                print(response)
                print(error)
            
        }
        
        //task.resume()
        
        
        
       
        let notFound = URL(string: "https://people.vcu.edu/~ebulut")
        
        
    
        
        let dataTask = session.dataTask(with: notFound!){data, response, error in
            print(data)
            print(response)
            print(error)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      print("error")
                      return
            }
            
        }
        
        dataTask.resume()
        
        
        let imageURL = URL(string: "https://news.vcu.edu/image/22f3218d-f513-4564-83df-6ab02f6785af")
        //download(from: imageURL!)
        
       
        
        downloadFile()
        
       
        //readLocalJSONData()
        
        //createJSONData()
        
        //getJSONData()
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        
        print("finished")
    }
    
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
                
            // update the percentage label
            DispatchQueue.main.async {
                self.percentLabel.text = "\(percentDownloaded * 100)%"
            }
        
    }
    
    
    func download(from url: URL) {
        
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
            
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
        
        
        
    }

    
    func downloadFile(){
        
        let sharedSession = URLSession.shared
       
       
        let url = URL(string: "http://www.people.vcu.edu/~ebulut/sampleFile.txt")
        
        print("downloading")
        
       
        
        let downloadTask = sharedSession.downloadTask(with: url!, completionHandler: { (location, response, err) in
            
            print("*** Location: \(location)")
            //print("*** suggested File name \((response?.suggestedFilename)!)")
            
            
            let dataFromURL = NSData(contentsOf: location!)
           
            let st = NSString(data: dataFromURL as! Data, encoding: String.Encoding.utf8.rawValue)
           
            print(st!)
        })
        
        downloadTask.resume()
        
        
        
        let imgUrl1 = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/VCU_Rams_logo.svg/250px-VCU_Rams_logo.svg.png")
     
        let downloadImageTask = sharedSession.downloadTask(with: imgUrl1!, completionHandler: {(location, response, err) in
            
            
            do{
                // construct the image from data at location
                let imData = try Data(contentsOf: location!)
               
                let img = UIImage(data: imData)
                
                // this needs to be run on the main thread
                DispatchQueue.main.async(execute: {
                    self.imgView.image = img
                    self.imgView.contentMode = .scaleAspectFit
                    
                    print("image downloaded")
                })
            }
            catch _{
                
            }
            
        })
        
        downloadImageTask.resume()
    }
    
    
    // TO READ JSON DATA from Internet
    func getJSONData(){
        
        let urlString1 = "http://api.openweathermap.org/data/2.5/find?q=NewYork&appid=881143b83f8b900d864067c69c4d96fe"
       
       let urlString = "https://samples.openweathermap.org/data/2.5/weather?q=London,uk&appid=b6907d289e10d714a6e88b30761fae22"
        
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        // create a data task
        let task = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let result = data{
                
                print("inside get JSON")
                print(result)
                do{
                    let json = try JSONSerialization.jsonObject(with: result, options: .fragmentsAllowed)
                    
                    if let dictionary = json as? [String:Any]{
                        print(dictionary["name"])
                    }
                }
                catch{
                    print("Error")
                }
            }
            
        })
        
        // always call resume() to start
        task.resume()
    }

    
    // TO READ LOCAL JSON DATA
    func readLocalJSONData(){
        print("inside read local JSON")
        
        let url = Bundle.main.url(forResource: "data", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                readJSONData(dictionary)
            }
            
        } catch {
            // Handle Error
        }
    }

    
    func readJSONData(_ object: [String: AnyObject]) {
        if let title = object["title"] as? String,
            let version = object["swiftVersion"] as? Float,
            let users = object["users"] as? [[String: AnyObject]] {
            
            for user in users {
                
                print("\(user["name"]!) is \(user["age"]!) years old")
            }
        }
    }
    
    func createJSONData(){
        
        // valid example
        let jsonExample1 = [
            "someString": "JSON",
            "someArrayName": [0, 1, 2, 3, 4, 5],
            "number": 1
            ] as [String : Any]
        
        // invalid example
        let jsonExample2 = [
            5: "key"
        ]
        
        if JSONSerialization.isValidJSONObject(jsonExample1) {
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonExample1, options: .prettyPrinted)
                
                let prettyPrintedJson =  NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                
                print("\(prettyPrintedJson)")
                
            }
            catch {
                // Handle Error
            }
        }
        else{
            print("not valid - example 1")
        }
        
        if JSONSerialization.isValidJSONObject(jsonExample2) {
            // NSJSONSerialization.dataWithJSONObject(validDictionary, options: .PrettyPrinted) will produce an error if called
        }
        else{
            print("not valid - example 2")
        }
    }

    

}

