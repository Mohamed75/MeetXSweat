/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Firebase
import JSQMessagesViewController



class ChatViewController: JSQMessagesViewController {
  
    
    var conversation: Conversation?
    
    fileprivate var _theMessages = [JSQMessage]()
  
    fileprivate var _outgoingBubbleImageView: JSQMessagesBubbleImage!
    fileprivate var _incomingBubbleImageView: JSQMessagesBubbleImage!
  
    
    fileprivate func setupBubbles() {
        
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        _outgoingBubbleImageView = bubbleImageFactory?.outgoingMessagesBubbleImage(with: Constants.MainColor.kSpecialColor)
        _incomingBubbleImageView = bubbleImageFactory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func viewDidLoad() {
        
        self.senderId           = User.currentUser.getEmailAsId()
        self.senderDisplayName  = User.currentUser.lastName
        
        super.viewDidLoad()
        setupBubbles()
        
        self.title = Strings.NavigationTitle.messages
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        inputToolbar.barTintColor    = UIColor.black
        inputToolbar.backgroundColor = UIColor.black
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: Ressources.Images.sendMessage), for: UIControlState())
        inputToolbar.contentView.rightBarButtonItemWidth = inputToolbar.contentView.rightBarButtonItem.frame.size.height
    }
    
    
    fileprivate func _messagesBlock() -> (_ messages: [Message]) -> Void {
        
        return { [weak self] (messages) in
            
            guard let this = self else {
                return
            }
            var allMessages = [JSQMessage]()
            for message in messages {
                allMessages.append(message.toJSQMessage())
            }
            this._theMessages = allMessages
            this.finishReceivingMessage()
        }
    }
    
    fileprivate func _typingBlock() -> (_ isTyping: Bool) -> Void {
        
        return { [weak self] (isTyping) in
            
            guard let this = self else {
                return
            }
            this.showTypingIndicator = isTyping
            this.scrollToBottom(animated: true)
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let aConversation = conversation else {
            return
        }
        aConversation.observeMessages(_messagesBlock())
        aConversation.observeTyping(senderId, completionHandler: _typingBlock())
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        guard let aConversation = conversation else {
            return
        }
        aConversation.removeObservers()
    }
    
  
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return _theMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _theMessages.count
    }
  
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = _theMessages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return _outgoingBubbleImageView
        } else { // 3
            return _incomingBubbleImageView
        }
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = _theMessages[indexPath.item]
        
        if message.senderId == senderId { // 1
            cell.textView!.textColor = UIColor.white // 2
        } else {
            cell.textView!.textColor = UIColor.black // 3
        }
        
        return cell
    }
  
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
  
  
  
  
  
  
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        guard let aConversation = conversation else {
            return
        }
        aConversation.isTyping = textView.text != ""
    }
  
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if let aConversation = conversation {
            aConversation.addMessage(text, senderId: senderId, controller: self)
            aConversation.isTyping = false
        }
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        finishSendingMessage()
    }
  
}
