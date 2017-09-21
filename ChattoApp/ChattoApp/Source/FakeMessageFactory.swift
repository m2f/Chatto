/*
 The MIT License (MIT)

 Copyright (c) 2015-present Badoo Trading Limited.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

import Foundation
import Chatto
import ChattoAdditions

extension Array {
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

func createMessageModel(_ uid: String, type: ChatItemType, text: String, isIncoming: Bool) -> Message {
    let senderId = isIncoming ? "1" : "2"
    let messageModel = Message(msgId: uid, msgType: type, senderId: senderId, isIncoming: isIncoming, date: Date(), status: MessageStatus.PENDING.rawValue, msgText: text)
    
    if type != MessageType.TEXT.rawValue {
        messageModel.image = UIImage(named: text)
    }
    return messageModel
}


class FakeMessageFactory {
    static let demoTexts = [
        "Lorem ipsum dolor sit amet 😇, https://github.com/badoo/Chatto consectetur adipiscing elit , sed do eiusmod tempor incididunt 07400000000 📞 ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore https://github.com/badoo/Chatto eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 07400000000 non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]

    class func createChatItem(_ uid: String) -> MessageModelProtocol {
        let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
        return self.createChatItem(uid, isIncoming: isIncoming)
    }

    class func createChatItem(_ uid: String, isIncoming: Bool) -> MessageModelProtocol {
        return self.createTextMessageModel(uid, isIncoming: isIncoming)
//        if arc4random_uniform(100) % 2 == 0 {
//            return self.createTextMessageModel(uid, isIncoming: isIncoming)
//        } else {
//            return self.createPhotoMessageModel(uid, isIncoming: isIncoming)
//        }
    }

    class func createTextMessageModel(_ uid: String, isIncoming: Bool) -> Message {
        let incomingText: String = isIncoming ? "incoming" : "outgoing"
        let maxText = self.demoTexts.randomItem()
        let length: Int = 10 + Int(arc4random_uniform(300))
        let text = uid//"\(maxText.substring(to: maxText.characters.index(maxText.startIndex, offsetBy: length))) incoming:\(incomingText), #:\(uid)"
        return ChattoApp.createMessageModel(uid, type: MessageType.TEXT.rawValue, text: text, isIncoming: isIncoming)
    }

    class func createPhotoMessageModel(_ uid: String, isIncoming: Bool) -> Message {
        var imageName: String
        switch arc4random_uniform(100) % 3 {
        case 0:
            imageName = "pic-test-1"
        case 1:
            imageName = "pic-test-2"
        case 2:
            fallthrough
        default:
            imageName = "pic-test-3"
        }
        return ChattoApp.createMessageModel(uid, type: MessageType.PHOTO.rawValue, text: imageName, isIncoming: isIncoming)
    }
}

class TutorialMessageFactory {
    static let messages = [
        (MessageType.TEXT.rawValue, "Welcome to Chatto! A lightweight Swift framework to build chat apps"),
        (MessageType.TEXT.rawValue, "It calculates sizes in the background for smooth pagination and rotation, and it can deal with thousands of messages with a sliding data source"),
        (MessageType.TEXT.rawValue, "Along with Chatto there's ChattoAdditions, with bubbles and the input component"),
        (MessageType.TEXT.rawValue, "This is a TextMessageCollectionViewCell. It uses UITextView with data detectors so you can interact with urls: https://github.com/badoo/Chatto, phone numbers: 07400000000, dates: 3 jan 2016 and others"),
        (MessageType.PHOTO.rawValue, "pic-test-1"),
        (MessageType.PHOTO.rawValue, "pic-test-2"),
        (MessageType.PHOTO.rawValue, "pic-test-3"),
        (MessageType.TEXT.rawValue, "Those were some PhotoMessageCollectionViewCell. With some fake data transfer"),
        (MessageType.TEXT.rawValue, "Both Text and Photo cells inherit from BaseMessageCollectionViewCell which adds support for a failed icon and a timestamp you can reveal by swiping from the right"),
        (MessageType.TEXT.rawValue, "Each message is paired with a Presenter. Each presenter is responsible to present a message by managing a corresponding UICollectionViewCell. New types of messages can be easily added by creating new types of presenters!"),
        (MessageType.TEXT.rawValue, "Messages have different margins and only some bubbles show a tail. This is done with a decorator that conforms to ChatItemsDecoratorProtocol"),
        (MessageType.TEXT.rawValue, "Failed/sending status are completly separated cells. This helps to keep cells them simpler. They are generated with the decorator as well, but other approaches are possible, like being returned by the DataSource or using more complex cells"),
        (MessageType.TEXT.rawValue, "More info on https://github.com/badoo/Chatto. We are waiting for your pull requests!")
    ] as [(Int32, String)]

    static func createMessages() -> [MessageModelProtocol] {
        var result = [MessageModelProtocol]()
        for (index, message) in self.messages.enumerated() {
            let type = message.0
            let content = message.1
            let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
            result.append(createMessageModel("tutorial-\(index)", type: type, text: content, isIncoming: isIncoming))
        }
        return result
    }
}

class SlidingTestMessageFactory {
    static func createMessages() -> [MessageModelProtocol] {
        var result = [MessageModelProtocol]()
        for i in 0..<100 {
            let type = MessageType.TEXT.rawValue
            let content = "\(i)\n"
            let isIncoming: Bool = arc4random_uniform(100) % 2 == 0
            result.append(createMessageModel("tutorial-\(index)", type: type, text: content, isIncoming: isIncoming))
        }
        return result
    }
}
