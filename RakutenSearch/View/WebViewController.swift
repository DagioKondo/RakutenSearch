//
//  WebViewController.swift
//  RakutenSearch
//
//  Created by 近藤大伍 on 2023/02/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let url: URL
    
    init(_ url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
    }
    
    private func setWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: self.view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
