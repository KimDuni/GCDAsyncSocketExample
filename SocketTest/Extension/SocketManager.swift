//
//  SocketManager.swift
//  SocketTest
//
//  Created by 성준 on 2022/01/18.
//

import Foundation
import CocoaAsyncSocket

let host: String = "192.168.120.254"
let port: UInt16 = 5500

protocol SocketManagerDelegate: AnyObject {
    func socketManager(_:SocketManager, status: String)
}

class SocketManager: NSObject {
    
    // MARK: - Properties
    
    private var gSocket: GCDAsyncSocket?
    weak var delegate: SocketManagerDelegate?
    
    // MARK: - LifeCycle
    
    override init() {
        super.init()
        self.setupSocket()
    }
}


// MARK: - GCDAsyncSocketDelegate

extension SocketManager: GCDAsyncSocketDelegate {
    
    func setupSocket() {
        gSocket = GCDAsyncSocket(delegate: self, delegateQueue: DispatchQueue.main) //dispatch_get_main_queue()
        gSocket?.isIPv4PreferredOverIPv6 = false
        gSocket?.isIPv6Enabled = true

        do {
            try gSocket?.connect(toHost: host, onPort: port)
        } catch let e {
            delegate?.socketManager(self, status: "접속 실패")
            print("접속 실패")
            print(e.localizedDescription)
        }
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("didConnect")
        
        delegate?.socketManager(self, status: "didConnect")
        var setting:[String: NSObject]!
        setting[GCDAsyncSocketManuallyEvaluateTrust] = NSNumber(booleanLiteral: true)
        sock.startTLS(setting)
    }
    
    func socketDidSecure(_ sock: GCDAsyncSocket) {
        gSocket?.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(true)
    }
    
    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("disConnect!")
        delegate?.socketManager(self, status: "disConnect!")
    }
    
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        let lock = NSLock()
        do {
            lock.withCriticalSection {
                print(data)
                if let dataStr = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    print(dataStr)
                }
            }
        }
    }
}


//    -(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
//
//        @try {
//            @synchronized (self) {
//                @try {
//                    if (data.length > 0) {
//                        //uint8_t *byte = (uint8_t *)[data bytes];
//                        uint8_t *byte = (uint8_t*)CFDataGetBytePtr((CFDataRef)data);
//                        int len = (int)CFDataGetLength((CFDataRef)data);
//
//                        [[MOAProtocolDecoder sharedInstance]packetDecode:byte len:len];
//                    }
//                } @catch (NSException *exception) {
//
//                }
//            }
//        } @finally {
//            [sock readDataWithTimeout:-1 tag:0];
//        }
//    }
