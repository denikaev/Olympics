//
//  VKClient.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class VKClient {
    
    // MARK: Constant properties
    private let APP_ID = "6256697"              // registered on vk.com
    private let VK_SEARCH_MAX_USERS = 500       // max search users limit       // #DEBUG up to 1000 !!!
    
    // MARK: Properties
    var userID = String()
    var token = String()
    
    var authorizationURL: URL? {
        let urlStr = "https://oauth.vk.com/authorize?client_id=\(APP_ID)&display=mobile&redirect_uri=" +
            "https://oauth.vk.com/blank.html&scope=friends,messages&response_type=token&revoke=1&v=5.6"
        return URL(string: urlStr)
    }
    
    // MARK: View Life Cycle
    init() {
        (self.userID, self.token) = DataManager.shared.getUserWithToken()
    }
    
    // MARK: Methods
    
    // Make request
    private func makeRequest(withURL url: URL, completion: @escaping (Data) -> () ) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            guard error == nil else { print(error?.localizedDescription ?? "makeRequest error"); return }
                completion(data)
            }.resume()
    }
    
    // Make request without completion
    private func makeRequest(withURL url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let _ = data else { return }
            guard error == nil else { print(error?.localizedDescription ?? "makeRequest error"); return }
            }.resume()
    }
    
    // Get current profile info
    func getProfileInfo(_ completion: @escaping (String?)->() ) {
        let urlStr = "https://api.vk.com/method/account.getProfileInfo?access_token=\(token)&v=5.68"
        guard let url = URL(string: urlStr) else { return }
        
        makeRequest(withURL: url) { (data) in
            completion( JSONParser().getProfileInfo(withData: data) )
        }
    }
    
    // Get user friends info
    func getFriends(_ completion: @escaping ([Friend])->() ) {
        let urlStr = "https://api.vk.com/method/friends.get?user_id=\(userID)&order=hints&fields=photo&v=3.0&access_token=\(token)"
        guard let url = URL(string: urlStr) else { return }
        
        makeRequest(withURL: url) { (data) in
            completion( JSONParser().getFriends(withData: data) )
        }
    }
    
    // Send message for user
    func sendMessage(forUserID user: Int, withMessage text: String) {
        let urlStr = "https://api.vk.com/method/messages.send?user_id=\(String(user))&message=\(text)&v=5.52&access_token=\(token)"
        guard let urlStrCyr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: urlStrCyr) else { return }
        makeRequest(withURL: url)
    }
    
    // Get messages hystory for friend
    // https://vk.com/dev/messages.getHistory
    func getChatHistory(forUserID user: Int, lastMessageCount count: Int = 10, completion: @escaping ([ChatMessage]?)->() ) {
        let urlStr = "https://api.vk.com/method/messages.getHistory?user_id=\(String(user))&count=\(count)&v=5.68&access_token=\(token)"
        guard let url = URL(string: urlStr) else { return }
        
        makeRequest(withURL: url) { (data) in
            completion( JSONParser().getChatHistory(withData: data) )
        }
    }
}
