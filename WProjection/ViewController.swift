//
//  ViewController.swift
//  WProjection
//
//  Created by HalseyW-15 on 2019/8/13.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import UIKit
import CocoaAsyncSocket
import Alamofire

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
        checkNetworkAccess()
    }

    /// 发送预备请求，获取iOS网络权限
    func checkNetworkAccess() {
        let request = Alamofire.request("https://www.baidu.com", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        request.response { [weak self] (response) in
            if response.error != nil {
                fatalError("network access error")
            } else {
                self?.connectToSSDP()
                self?.sendSSDPSearchData()
            }
        }
    }
    
    /// 连接到SSDP
    func connectToSSDP() {
        ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: DispatchQueue.main)
        try! ssdpSocket.bind(toPort: ssdpPort)
        try! ssdpSocket.joinMulticastGroup(ssdpAddress)
        try! ssdpSocket.beginReceiving()
    }
    
    /// SSDP搜索设备
    func sendSSDPSearchData() {
        ssdpSocket.send(mSearchData!, toHost: ssdpAddress, port: ssdpPort, withTimeout: 1, tag: 0)
    }
    
}

extension ViewController: GCDAsyncUdpSocketDelegate {
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        print("From \(GCDAsyncUdpSocket.host(fromAddress: address)!)")
        let searchData = String(data: data, encoding: .utf8)!
        print(searchData)
    }
    
}
