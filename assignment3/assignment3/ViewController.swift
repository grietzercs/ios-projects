//
//  ViewController.swift
//  assignment3
//
//  Created by Colden on 3/21/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let buttonX = 450
        let buttonY = 350
        let buttonWidth = 100
        let buttonHeight = 50

        let button = UIButton(type: .system)
        button.setTitle("Click here", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
//        button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        button.widthAnchor.constraint(equalToConstant: 384)
//        button.heightAnchor.constraint(equalToConstant: 512)
        button.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        //button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }


}

