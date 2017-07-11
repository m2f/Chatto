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
import ChattoAdditions

public class DemoTextMessageViewModel: TextMessageViewModelProtocol {

    let message: Message
    public let messageViewModel: MessageViewModelProtocol
    
    public var text: String {
        return message.msgText
    }
    
    init(message: Message, messageViewModel: MessageViewModelProtocol) {
        self.message = message
        self.messageViewModel = messageViewModel
    }
}

public class DemoTextMessageViewModelBuilder: ViewModelBuilderProtocol {
    public init() {}

    let messageViewModelBuilder = MessageViewModelDefaultBuilder()

    public func createViewModel(_ textMessage: Message) -> DemoTextMessageViewModel {
        let messageViewModel = self.messageViewModelBuilder.createMessageViewModel(textMessage)
        let textMessageViewModel = DemoTextMessageViewModel(message: textMessage, messageViewModel: messageViewModel)
        textMessageViewModel.avatarImage.value = UIImage(named: "userAvatar")
        textMessageViewModel.statusImage = UIImage(named: "ic_icon_duration")
        return textMessageViewModel
    }

    public func canCreateViewModel(fromModel model: Any) -> Bool {
        return model is Message
    }
}
