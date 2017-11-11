//
//  LoginViewController.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func loginTap(_ sender: UIButton) {
        if DataManager.shared.isUserAutorized() {
            performSegue(withIdentifier: "segueFriendsList", sender: self)
        } else {
            login()
        }
    }
    
    @IBAction func backTap(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set back button in navigation bar
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: nil)
    }
}

extension LoginViewController: UIWebViewDelegate {
    
    // Log in vk.com for autorization
    func login() {
        if let url = VKClient().authorizationURL {
            let webView = UIWebView(frame: view.bounds)
            webView.delegate = self
            webView.loadRequest( URLRequest(url: url) )
            view.addSubview(webView)
        }
    }
    
    // Get request when loading data to WebView
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        switch DataManager.shared.requestAnalitics(forRequest: request) {
        case .accessAllowed:
            webView.removeFromSuperview()
            performSegue(withIdentifier: "segueFriendsList", sender: self)
        case .accessDenied:
            DataManager.shared.eraseUserData()
            webView.removeFromSuperview()
        default:
            break
        }
        return true
    }
    
    // Load data in WebView did finish
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print(">>> Finish load...")     // #DEBUG Func?
    }
    
    // Load data in WebView with errors
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Loading error: \(error)")        // #DEBUG
        webView.removeFromSuperview()
    }
}
