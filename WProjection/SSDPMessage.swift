//
//  SSDPMessage.swift
//  WProjection
//
//  Created by HalseyW-15 on 2019/8/16.
//  Copyright © 2019 wushhhhhh. All rights reserved.
//

import Foundation

struct SSDPMessage {
    static let searchData = """
                            M-SEARCH * HTTP/1.1
                            MAN: "ssdp:discover"
                            MX: 5
                            HOST: 239.255.255.250:1900
                            ST: urn:schemas-upnp-org:service:AVTransport:1
                            """.data(using: .utf8)!
}
