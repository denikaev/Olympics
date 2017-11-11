//
//  JSONModels.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

// MARK: getProfileInfo data
// Info data
struct JSONProfileInfo: Decodable {
    var response: JSONProfileItem
}

struct JSONProfileItem: Decodable {
    var first_name: String
    var last_name: String
    var sex: Int
    var relation: Int
    var bdate: String
    var bdate_visibility: Int
    var home_town: String
    var status: String
    var phone: String
}

// Error data
struct JSONProfileError: Decodable {
    var error: JSONProfileErrorDescription
}

struct JSONProfileErrorDescription: Decodable {
    var error_code: Int
    var error_msg: String
    var request_params: [JSONProfileErrorParams]
}

struct JSONProfileErrorParams: Decodable {
    var key: String
    var value: String
}

// MARK: getFriends data
struct JSONFriend: Decodable {
    var response: [JSONFriendItem]
}

struct JSONFriendItem: Decodable {
    var uid: Int
    var first_name: String
    var last_name: String
    var photo: String
    var online: Int
    var user_id: Int
}

// MARK: searchUsers data
struct JSONUser: Decodable {
    var response: JSONUserResponse
}

struct JSONUserResponse: Decodable {
    var count: Int
    var items: [JSONUserItem]
}

struct JSONUserItem: Decodable {
    var id: Int
    var first_name: String
    var last_name: String
    var bdate: String?
    var city: JSONCity?
    var country: JSONCountry?
    var photo: String
    var photo_max_orig: String
    var is_friend: Int
    var online: Int
}

// MARK: getChatHistory data
struct JSONChatMessage: Decodable {
    var response: Response
}

struct Response: Decodable {
    var count: Int
    var items: [Item]
    var in_read: Int
    var out_read: Int
}

struct Item: Decodable {
    var id: Int
    var date: Int
    var out: Int
    var user_id: Int
    var from_id: Int
    var read_state: Int
    var body: String
    var emoji: Int?
    var random_id: Int?
}

// MARK: getFriendshipStatus data
struct JSONFriendshipStatus: Decodable {
    var response: [JSONFriendshipStatusResponse]
}

struct JSONFriendshipStatusResponse: Decodable {
    var user_id: Int
    var friend_status: Int
    var sign: String?
}

// MARK: addUserToFriends data
struct JSONAddFriend: Decodable {
    var response: Int
}

// MARK: - Universal JSON models

// Country
struct JSONCountry: Decodable {
    var id: Int
    var title: String
}

// City
struct JSONCity: Decodable {
    var id: Int
    var title: String
}


