//
//  ChatController.swift
//  Relax
//
//  Created by Sergey Bizunov on 12.11.2017.
//  Copyright © 2017 Sergey Bizunov. All rights reserved.
//

import UIKit

class ChatController: UIViewController {

    // MARK: Properties
    let TEXTFIELD_MAX_LENGTH = 100                  // max length for chat message
    let CHAT_MAX_MESSAGE_COUNT = 20                 // max count of chat history
    let CHAT_UPDATE_INTERVAL: TimeInterval = 2      // chat update interval in seconds
    
    var isScrollChatNeeded = false                  // scroll chat flag
    var isScrollChatForced = false
    var timer = Timer()                             // timer for chat
    var friend = Friend()                           // current user info
    var messages = [ChatMessage]()                  // chat history
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    
    // MARK: IBActions
    
    // Button SEND
    @IBAction func sendButtonClick(_ sender: UIButton) {
        if let text = textField.text, !text.isEmpty {
            VKClient().sendMessage(forUserID: friend.user_id, withMessage: text)
            textField.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle()
        setPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
        getChatMessagesFromVK()
        timerStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotification()
        timerStop()
    }
    
    // MARK: Methods
    
    // Set navigation bar title
    fileprivate func setTitle() {
        var name = friend.first_name.capitalized
        if name.isEmpty { name = friend.last_name.capitalized }
        else { name += " " + friend.last_name.capitalized}
        if name.isEmpty { name = "noname  =))" }
        self.navigationItem.title = name
    }
    
    // Set textfield placeholder
    func setPlaceholder() {
        if let ph = textField.placeholder {
            textField.placeholder = " \(ph) (\(TEXTFIELD_MAX_LENGTH) characters max)"
        }
    }
    
    // Registering keyboard listeners
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow),
                                               name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide),
                                               name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Deleting keyboard listeners
    func removeKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Get chat messages from vk.com
    func getChatMessagesFromVK() {
        VKClient().getChatHistory(forUserID: friend.user_id, lastMessageCount: CHAT_MAX_MESSAGE_COUNT) { chatMessages in
            if let messages = chatMessages {
                //print(">>> [ChatController.getChatMessagesFromVK] messages=\(messages)")    // #DEBUG
                DispatchQueue.main.async {
                    self.messages = messages
                    self.tableView.reloadData()
                    self.scrollChatToLastRowIfNeeded()
                }
            } else { print(">>> [ChatController.getChatMessagesFromVK] ERROR MESSAGES") }   // #DEBUG
        }
    }
    
    // Scroll down the chat if needed
    func scrollChatToLastRowIfNeeded() {
        if isScrollChatNeeded || isScrollChatForced {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            isScrollChatNeeded = false
        }
    }
    
    // MARK: Timer methods for chat update
    
    // Start timer
    func timerStart() {
        timer = Timer.scheduledTimer(timeInterval: CHAT_UPDATE_INTERVAL, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
    }
    
    // Timer action
    @objc func timerAction() {
        print(">>> [TIMER] [\(Date())] Check the chat...")    // #DEBUG
        getChatMessagesFromVK()
        scrollChatToLastRowIfNeeded()
    }
    
    // Stop timer
    func timerStop() {
        timer.invalidate()
    }
}

// ChatField extension
extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].user_id != messages[indexPath.row].from_id {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserChatCell", for: indexPath) as! UserCell
            
            // Configure the cell...
            cell.message = messages[indexPath.row].body
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendChatCell", for: indexPath) as! FriendCell
            
            // Configure the cell...
            cell.message = messages[indexPath.row].body
            
            return cell
        }
    }
}

// TextField extension
extension ChatController: UITextFieldDelegate {
    
    // Сorrect input validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") as NSString
        let resultText = text.replacingCharacters(in: range, with: string)
        return resultText.count <= TEXTFIELD_MAX_LENGTH
    }
    
    // Returns the input focus
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Появление клавиатуры
    @objc func keyboardShow(_ notification: Notification) {
        moveTextField(isKeyboardShow: true, notification: notification)
    }
    
    // Исчезновение клавиатуры
    @objc func keyboardHide(_ notification: Notification) {
        moveTextField(isKeyboardShow: false, notification: notification)
    }
    
    func moveTextField(isKeyboardShow show: Bool, notification: Notification) {
        if let userInfo = notification.userInfo, let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = value.cgRectValue.height
            
            // Сalculation of new dimensions
            let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0.0
            let addViewHeight = (keyboardHeight - tabBarHeight) * (show ? 1 : -1)
            
            // Replace UI elements
            print("[MoveTextField] keyboardHeight=\(keyboardHeight),tabBarHeight=\(tabBarHeight), addViewHeight=\(addViewHeight)")
            textFieldBottomConstraint.constant += addViewHeight
            sendButtonBottomConstraint.constant += addViewHeight
        }
    }
    
    // Hide keyboard if user tap on view
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
