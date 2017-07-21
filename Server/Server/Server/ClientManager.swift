//
//  ClientManager.swift
//  Server
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

protocol ClientManagerDelegate : class {
    
    func removeClient(clientMgr : ClientManager)
    
    func receiveData(data : Data)
}

class ClientManager: NSObject {
    
    var tcpClient : TCPClient
    
    fileprivate lazy var isClientConnected : Bool = false
    
    weak var delegate : ClientManagerDelegate?
    
    
    init(tcpClient : TCPClient) {
        self.tcpClient = tcpClient
    }

}


extension ClientManager {
    
    func startReadMsg() {
        
        print("开始接收消息")
        
        isClientConnected = true
        
        while isClientConnected {
            
            if let lMsg = tcpClient.read(4) {
                // 1.读取长度的data
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                (headData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型
                guard let typeMsg = tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                (typeData as NSData).getBytes(&type, length: 2)
                
                // 2.根据长度, 读取真实消息
                guard let msg = tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
//                let str = String(data: data, encoding: .utf8)
                
//                let totalData = headData + typeData + data
//                
//                tcpClient.send(data: totalData)
                
                delegate?.receiveData(data: data)

            } else {
                removeClient()
            }
            
        }
    }
    
    func removeClient() {
        
        switch tcpClient.close().0 {
        case true:
            isClientConnected = false
            delegate?.removeClient(clientMgr: self)
            print("客户端断开了链接")
        default:
            print("移除client失败")
        }
    }
}
