//
//  ViewController.swift
//  Client
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var contentLabel: NSTextField!
    
    @IBOutlet weak var textField: NSTextField!
    
    @IBOutlet weak var connectBtn: NSButton!
    
    @IBOutlet weak var closeBtn: NSButton!
    
    @IBOutlet weak var sendBtn: NSButton!
    
    fileprivate lazy var textArrs : TextArrs = TextArrs(count: 12)
    
    fileprivate lazy var clientMgr : ClientManager = ClientManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        connectBtn.isEnabled = true
        closeBtn.isEnabled = false
        sendBtn.isEnabled = false
        
    }


    @IBAction func connectToServer(_ sender: NSButton) {
        
        let result = clientMgr.connectToServer()
        switch result.0 {
        case true:
            connectBtn.isEnabled = false
            closeBtn.isEnabled = true
            sendBtn.isEnabled = true
            contentLabel.stringValue = textArrs.append(str: result.1)
            
        case false:
            connectBtn.isEnabled = true
            closeBtn.isEnabled = false
            sendBtn.isEnabled = false
            contentLabel.stringValue = textArrs.append(str: result.1)
        }
    }
    
    @IBAction func sendMsg(_ sender: NSButton) {
        
        let msg = clientMgr.sendMsg(str: textField.stringValue).1
        print(msg)
        textField.stringValue = ""
        
    }

    @IBAction func closeConnect(_ sender: NSButton) {
        
        let msg = clientMgr.close().1
        print(msg)
        connectBtn.isEnabled = true
        closeBtn.isEnabled = false
        sendBtn.isEnabled = false
        
    }
}

