//
//  ServerManager.swift
//  Server
//
//  Created by ifuwo on 2017/7/20.
//  Copyright © 2017年 ifuwo. All rights reserved.
//

import Cocoa

protocol ServerManagerDelegate : class {
    
    func receiveData(data: Data)
}

class ServerManager: NSObject {

    fileprivate lazy var tcpServer : TCPServer = TCPServer(addr: "0.0.0.0", port: 8888)
    
    // 开启和关闭服务器的标示
    fileprivate var isServerRunning : Bool = false
    
    // 存储clientMgr的数组
    fileprivate lazy var ClientMgrs : [ClientManager] = [ClientManager]()
    
    // 代理
    weak var delegate : ServerManagerDelegate?
    
}

extension ServerManager {
    
    func startServer() -> (Bool, String) {
        
        // 监听
        let listenRes = tcpServer.listen()
        if listenRes.0 {
            isServerRunning = true
            
            // 接收客户端请求
            DispatchQueue.global().async {
                
                while self.isServerRunning {
                    
                    if let tcpClient = self.tcpServer.accept() {
                        
                        print("新的连接")
                        
                        let clientMgr = ClientManager(tcpClient: tcpClient)
                        
                        clientMgr.delegate = self
                        
                        self.ClientMgrs.append(clientMgr)
                        
                        DispatchQueue.global().async {
                            
                            clientMgr.startReadMsg()
                            
                        }
                    }
                }
            }
        }
        
        return listenRes
    }
    
    func stopServer() -> (Bool, String) {
        
        isServerRunning = false
        return tcpServer.close()
        
    }
}

extension ServerManager : ClientManagerDelegate {
    
    func removeClient(clientMgr: ClientManager) {
        
        if let index = ClientMgrs.index(of: clientMgr) {
            ClientMgrs.remove(at: index)
        }
        
    }
    
    func receiveData(data : Data) {
        
        delegate?.receiveData(data: data)
        
    }
    
    
    
}
