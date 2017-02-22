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
    
    var theMessages = [JSQMessage]()
  
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
  
    
    private func setupBubbles() {
        
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(Constants.MainColor.kSpecialColor)
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func viewDidLoad() {
        
        self.senderId           = User.currentUser.getEmailAsId()
        self.senderDisplayName  = User.currentUser.lastName
        
        super.viewDidLoad()
        setupBubbles()
        
        self.title = Strings.NavigationTitle.messages
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        inputToolbar.barTintColor    = UIColor.blackColor()
        inputToolbar.backgroundColor = UIColor.blackColor()
        inputToolbar.contentView.rightBarButtonItem.setImage(UIImage(named: Ressources.Images.sendMessage), forState: .Normal)
        inputToolbar.contentView.rightBarButtonItemWidth = inputToolbar.contentView.rightBarButtonItem.frame.size.height
    }
  
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let aConversation = conversation {
            
            aConversation.observeMessages( { [weak self] (messages) in
                
                guard let this = self else {
                    return
                }
                var allMessages = [JSQMessage]()
                for message in messages {
                    allMessages.append(message.toJSQMessage())
                }
                this.theMessages = allMessages
                this.finishReceivingMessage()
            })
            
            aConversation.observeTyping(senderId) { [weak self] (isTyping) in
                
                guard let this = self else {
                    return
                }
                this.showTypingIndicator = isTyping
                this.scrollToBottomAnimated(true)
            }
        }
    }
  
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        if let aConversation = conversation {
            aConversation.removeObservers()
        }
    }
    
  
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return theMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theMessages.count
    }
  
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = theMessages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
  
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = theMessages[indexPath.item]
        
        if message.senderId == senderId { // 1
            cell.textView!.textColor = UIColor.whiteColor() // 2
        } else {
            cell.textView!.textColor = UIColor.blackColor() // 3
        }
        
        return cell
    }
  
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
  
  
  
  
  
  
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        if let aConversation = conversation {
            aConversation.isTyping = textView.text != ""
        }
    }
  
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        if let aConversation = conversation {
            aConversation.addMessage(text, senderId: senderId, controller: self)
        }
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        
        if let aConversation = conversation {
            aConversation.isTyping = false
        }
    }
  
}