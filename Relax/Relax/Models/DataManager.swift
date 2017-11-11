//
//  DataManager.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

final class DataManager {
    // MARK: Constant keys for UserDefaults
    // User keys
    private let UD_KEY_USER_ID = "UserID"
    private let UD_KEY_TOKEN = "Token"
    
    // MARK: Properties
    static let shared = DataManager()
    
    private var userID: String
    private var token: String
    
    // MARK: View Life Cycle
    private init() {
        self.userID = UserDefaults.standard.string(forKey: UD_KEY_USER_ID) ?? ""
        self.token = UserDefaults.standard.string(forKey: UD_KEY_TOKEN) ?? ""
    }
    
    // MARK: Methods
    
    // Analysis of server response and return of response status
    func requestAnalitics(forRequest request: URLRequest) -> AnaliticStatus {
        var params = [String: String]()
        if let url = request.url, let fragment = url.fragment {
            let arrayComponents = fragment.components(separatedBy: "&")
            if arrayComponents.count > 0 {
                for item in arrayComponents {
                    let pair = item.components(separatedBy: "=")
                    params[pair[0]] = pair[1]
                }
                print("params = \(params)")     // #DEBUG
            }
        } else { return .other }
        
        // Request params analitics
        if let token = params["access_token"], let userID = params["user_id"] {
            print(">>> [Analitics]  token=\(token)\nuser_id=\(userID)")      // #DEBUG
            DataManager.shared.saveUserData(withParams: params)
            return .accessAllowed
        }
        else if let error = params["error"] {
                if error == "access_denied" { return .accessDenied }
        }
        
        return .other
    }
    
    // MARK: Methods with User Data
    
    // Verify user autorization
    func isUserAutorized() -> Bool {
        print(">>> [isUserAutorized]  userID=\(userID)  token=\(token)")        // #DEBUG
        if !userID.isEmpty && !token.isEmpty { return true }
        return false
    }
    
    // Get base user data (userID, token) - some of them may be empty !
    func getUserWithToken() -> (userID: String, token: String) {
        return (userID, token)
    }
    
    // Save user data to UserDefaults and refresh self.variables
    func saveUserData(withParams params: [String: String]) {
        if let userID = params["user_id"] {
            self.userID = userID
            UserDefaults.standard.set(userID, forKey: UD_KEY_USER_ID)
        }
        if let token = params["access_token"] {
            self.token = token
            UserDefaults.standard.set(token, forKey: UD_KEY_TOKEN)
        }
    }
    
    // Erase user data, user need get authorization
    func eraseUserData() {
        UserDefaults.standard.set("", forKey: UD_KEY_TOKEN)
        token = ""
    }
    
    // Check user data from UserDefaults                    // #DEBUG   not used?
    func checkUserDataFromUserDefaults() -> Bool {
        if let userID = UserDefaults.standard.string(forKey: UD_KEY_USER_ID), !userID.isEmpty {
            if let token  = UserDefaults.standard.string(forKey: UD_KEY_TOKEN), !token.isEmpty {
                print(">>> checkUserData:  userID=\(userID), token=\(token)")       // #DEBUG
                self.userID = userID
                self.token = token
                return true
            }
            else { print(">>> checkUserData: token =(((") }   // #DEBUG
        }
        else { print(">>> checkUserData: userID =(((") }  // #DEBUG
        
        return false
    }
}
