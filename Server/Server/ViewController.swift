//
//  ViewController.swift
//  Server
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var stopServerBtn: NSButton!
    
    @IBOutlet weak var startServerBtn: NSButton!
    
    @IBOutlet weak var content: NSTextField!
    
    fileprivate lazy var serverMgr : ServerManager = ServerManager()
    
    fileprivate lazy var textArrs : TextArrs = TextArrs(count: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        serverMgr.delegate = self
    }
}

extension ViewController {
    
    @IBAction func startServer(_ sender: NSButton) {
        
        let startServerRes = serverMgr.startServer()
        content.stringValue = textArrs.append(str: startServerRes.1)
    }
    
    @IBAction func stopServer(_ sender: NSButton) {
        
        let stopServerRes = serverMgr.stopServer()
        content.stringValue = textArrs.append(str: stopServerRes.1)
        
    }
    
}

extension ViewController : ServerManagerDelegate {
    
    func receiveData(data: Data) {
        
        let string = String(data: data, encoding: .utf8)

        DispatchQueue.main.async {
            self.content.stringValue = self.textArrs.append(str: string!)
        }
    }
}

