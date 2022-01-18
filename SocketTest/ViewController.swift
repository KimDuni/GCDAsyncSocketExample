//
//  ViewController.swift
//  SocketTest
//
//  Created by 성준 on 2022/01/18.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IB
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Properties
    
    private var socketManager: SocketManager?
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socketManager = SocketManager()
        socketManager?.delegate = self
    }
}

// MARK: - SocketManagerDelegate

extension ViewController: SocketManagerDelegate {
    func socketManager(_: SocketManager, status: String) {
        DispatchQueue.main.async {
            self.statusLabel.text = status
        }
    }
}


