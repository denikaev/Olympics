//
//  Models.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

// MARK: Friend

struct Friend {
    var user_id: Int = -1
    var first_name: String = ""
    var last_name: String = ""
    var photo: String = ""
    var online: Bool = false
}

// MARK: Chat message
struct ChatMessage {
    var id: Int = -1
    var user_id: Int = -1
    var from_id: Int = -1
    var date: Int = -1
    var body: String = ""
    var emoji: Bool = false
}

// MARK: Type for request analitics
enum AnaliticStatus {
    case accessDenied       // return when access denied, user tap for "Cancel" button
    case accessAllowed      // return when access allowed
    case other              // ... other event or error
}



