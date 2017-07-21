//
//  ClientManager.swift
//  Client
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

class ClientManager: NSObject {

    fileprivate lazy var tcpClient : TCPClient = TCPClient(addr: "127.0.0.1", port: 8888)
    
}

extension ClientManager {
    
    func connectToServer() -> (Bool,String) {
        
        return tcpClient.connect(timeout: 5)
        
    }
    
    func sendMsg(str : String) -> (Bool,String) {
        
        guard let data = str.data(using: .utf8) else {
            return (false, "数据问题")
        }
        
        // 1.将消息长度, 写入到data
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 2.消息类型
        var tempType = 1
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 3.发送消息
        let totalData = headerData + typeData + data
        return tcpClient.send(data: totalData)
    }
    
    func close() -> (Bool,String) {
        return tcpClient.close()
    }
}
