//
//  TOSWebViewController.swift
//  VODA_iOS
//
//  Created by 조윤영 on 2022/03/20.
//

import UIKit
import WebKit

class TOSWebViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationUI()
        
        if let TOSUrl = url {
            webView.load(URLRequest(url: TOSUrl))
        }
    }
    
    private func setUpNavigationUI() {
        self.setBackButton(color: .black)
        self.setNavigationBarTransparency()
    }
}
