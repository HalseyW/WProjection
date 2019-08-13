//
//  ViewController.swift
//  WProjection
//
//  Created by HalseyW-15 on 2019/8/13.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import SnapKit

class ViewController: UIViewController {
    let mSearchData = "M-SEARCH * HTTP/1.1\r\nMAN: \"ssdp:discover\"\r\nMX: 5\r\nHOST: 239.255.255.250:1900\r\nST: ssdp:all\r\n".data(using: .utf8)
    //ssdp stuff
    var ssdpAddres = "239.255.255.250"
    var ssdpPort: UInt16 = 1900
    var ssdpSocket: GCDAsyncUdpSocket!
    var ssdpSocketRec: GCDAsyncUdpSocket!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.backgroundColor = .black
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
        button.addTarget(self, action: #selector(onClickSendMsgButton), for: .touchUpInside)
        
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        try! ssdpSocket.bind(toPort: ssdpPort)
        try! ssdpSocket.beginReceiving()
        try! ssdpSocket.enableBroadcast(true)
        try! ssdpSocket.joinMulticastGroup(ssdpAddres)
        try! ssdpSocket.connect(toHost: ssdpAddres, onPort: ssdpPort)
    }
    
    @objc func onClickSendMsgButton() {
        ssdpSocket.send(mSearchData!, toHost: ssdpAddres, port: ssdpPort, withTimeout: 5, tag: 0)
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
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("button")
    }
    
}

