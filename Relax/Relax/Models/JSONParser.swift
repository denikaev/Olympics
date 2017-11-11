//
//  JSONParser.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class JSONParser {
    
    // Parse JSON response with profile info
    func getProfileInfo(withData data: Data) -> String? {
        // Parse profile info
        do {
            let profile = try JSONDecoder().decode(JSONProfileInfo.self, from: data)
            let result = profile.response.first_name.capitalized + " " +
                profile.response.last_name.capitalized
            //print(">>> [JSONParser] getProfileInfo: \(result)")       // #DEBUG
            return result
        } catch let error { print(error)
            // Parse errors if profile info isn't received
            do {
                let err = try JSONDecoder().decode(JSONProfileError.self, from: data)
                let errCode = err.error.error_code      // #DEBUG
                let errMsg = err.error.error_msg        // #DEBUG
                print(">>> [JSONParser.getProfileInfo] error_code=\(errCode)  error_msg=\(errMsg)")  // #DEBUG
            } catch let error { print(error) }
        }
        return nil
    }
    
    // Parse JSON response to friends array
    func getFriends(withData data: Data) -> [Friend] {
        do {
            let jsonFriends = try JSONDecoder().decode(JSONFriend.self, from: data)
            
            if jsonFriends.response.count > 0 {
                var friends = [Friend]()
                for item in jsonFriends.response {
                    let newFriend = Friend(user_id: item.user_id,
                                           first_name: item.first_name,
                                           last_name: item.last_name,
                                           photo: item.photo,
                                           online: item.online == 1 ? true : false)
                    //print(">>> [JSONParser] append element \(newFriend)")       // #DEBUG
                    friends.append(newFriend)
                }
                return friends
            }
        } catch let error { print(error) }
        return []
    }
    
    // Parse JSON chat history
    func getChatHistory(withData data: Data) -> [ChatMessage]? {
        do {
            let chat = try JSONDecoder().decode(JSONChatMessage.self, from: data)
            if chat.response.items.count > 0 {
                var messages = [ChatMessage]()
                for item in chat.response.items {
                    let message = ChatMessage(id: item.id,
                                              user_id: item.user_id,
                                              from_id: item.from_id,
                                              date: item.date,
                                              body: item.body,
                                              emoji: item.emoji == 1 ? true : false)
                    messages.append(message)
                }
                return messages.reversed()
            }
        } catch let error { print(error) }
        
        return nil
    }
}
