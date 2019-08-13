//
//  ViewController.swift
//  WProjection
//
//  Created by HalseyW-15 on 2019/8/13.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController {
    let mSearchData = """
                        M-SEARCH * HTTP/1.1
                        MAN: "ssdp:discover"
                        MX: 5
                        HOST: 239.255.255.250:1900
                        ST: ssdp:all
                      """.data(using: .utf8)
    //ssdp stuff
    var ssdpAddres = "239.255.255.250"
    var ssdpPort: UInt16 = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var ssdpSocketRec: GCDAsyncUdpSocket!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        
        try! ssdpSocket.bind(toPort: ssdpPort)
        try! ssdpSocket.beginReceiving()
        try! ssdpSocket.enableBroadcast(true)
        try! ssdpSocket.joinMulticastGroup(ssdpAddres)
        try! ssdpSocket.connect(toHost: ssdpAddres, onPort: ssdpPort)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ssdpSocket.send(mSearchData!, toHost: ssdpAddres, port: ssdpPort, withTimeout: 1, tag: 0)
    }
    
}

extension ViewController: GCDAsyncUdpSocketDelegate {
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didConnectToAddress address: Data) {
        print("didConnectToAddress: \(address)")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        var host: NSString?
        var port1: UInt16 = 0
        GCDAsyncUdpSocket.getHost(&host, port: &port1, fromAddress: address)
        print("From \(host!)")
        
        let gotData = String(data: data, encoding: .utf8)!
        print(gotData)
    }
    
}

