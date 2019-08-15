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
                        HOST: 239.255.255.250:1900
                        MAN: "ssdp:discover"
                        MX: 3
                        ST: urn:schemas-upnp-org:service:AVTransport:1
                      """.data(using: .utf8)
    
    var ssdpAddress = "239.255.255.250"
    var ssdpPort: UInt16 = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var ssdpSocketRec: GCDAsyncUdpSocket!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        try! ssdpSocket.bind(toPort: ssdpPort)
        try! ssdpSocket.joinMulticastGroup(ssdpAddress)

        ssdpSocket.send(mSearchData!, toHost: ssdpAddress, port: ssdpPort, withTimeout: 1, tag: 0)
        try! ssdpSocket.beginReceiving()
    }
    
}

extension ViewController: GCDAsyncUdpSocketDelegate {
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        print("From \(GCDAsyncUdpSocket.host(fromAddress: address)!)")
        let searchData = String(data: data, encoding: .utf8)!
        print(searchData)
    }
    
}
