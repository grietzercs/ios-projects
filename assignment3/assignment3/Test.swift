//
//  Test.swift
//  assignment3
//
//  Created by Colden on 3/30/22.
//

import UIKit

class Test: UIViewController {
    
    var data = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        let testLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        testLabel.text = "TEST: \(data)"
        testLabel.backgroundColor = .black
        testLabel.textColor = .red
        testLabel.textAlignment = .center
        view.addSubview(testLabel)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
