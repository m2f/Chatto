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

import UIKit
import Chatto
import ChattoAdditions

class DemoChatViewController: BaseChatViewController {

    var messageSender: FakeMessageSender!
    var dataSource: FakeDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }

    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "bubble-incoming-tail-border", in: Bundle(for: DemoChatViewController.self), compatibleWith: nil)?.bma_tintWithColor(.blue)
        super.chatItemsDecorator = ChatItemsDemoDecorator()
        let addIncomingMessageButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(DemoChatViewController.addRandomIncomingMessage))
        self.navigationItem.rightBarButtonItem = addIncomingMessageButton
        
        let markRead = UIBarButtonItem(title: "Read", style: .plain, target: self, action: #selector(markAsRead))
        self.navigationItem.leftBarButtonItem = markRead
        
        super.collectionView.backgroundView = UIImageView(image: UIImage(named: "whatsapp_bg"))
        
    }
    
    @objc
    private func markAsRead() {
        self.dataSource.markRead()
    }

    @objc
    private func addRandomIncomingMessage() {
        self.dataSource.addRandomIncomingMessage()
    }

    var chatInputPresenter: BasicChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonAppearance.title = NSLocalizedString("Send", comment: "")
        appearance.sendButtonAppearance.insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        appearance.textInputAppearance.textInsets = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        appearance.textInputAppearance.placeholderText = NSLocalizedString("Type a message", comment: "")
        self.chatInputPresenter = BasicChatInputBarPresenter(chatInputBar: chatInputView, chatInputItems: self.createChatInputItems(), chatInputBarAppearance: appearance)
        chatInputView.maxCharactersCount = 1000
        return chatInputView
    }

    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        
        let textMessagePresenter = TextMessagePresenterBuilder(
            viewModelBuilder: DemoTextMessageViewModelBuilder(),
            interactionHandler: DemoTextMessageHandler(baseHandler: self.baseMessageHandler)
        )
        
        let font = UIFont(name: "PTSans-Regular", size: 16)!
        let fontTime = UIFont(name: "PTSans-Regular", size: 14)!
        let ACCENT = UIColor(red: 254/255, green: 120/255, blue: 71/255, alpha: 1)
        let TEXT_DARK = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
        let TEXT_LIGHT = UIColor(red: 83/255, green: 83/255, blue: 88/255, alpha: 1)
        let WHITE = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let WHITE_70 = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)


        
        let textStyle = TextMessageCollectionViewCellDefaultStyle.TextStyle(
            font: font,
            incomingColor: TEXT_DARK,
            outgoingColor: WHITE,
            timeAndStatusFont: fontTime,
            timeAndStatusIncomingColor: TEXT_LIGHT,
            timeAndStatusOutgoingColor: WHITE_70,
            incomingInsets: UIEdgeInsets(top: 10, left: 19, bottom: 10, right: 15),
            outgoingInsets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 19))
        
        let bubbleColors = BaseMessageCollectionViewCellDefaultStyle.Colors(
            incoming: WHITE,
            outgoing: ACCENT)
        
        let avatarStyle = BaseMessageCollectionViewCellDefaultStyle.AvatarStyle(
            size: CGSize(width: 35, height: 35),
            alignment: .center)

        let dateSeparatorStyle = BaseMessageCollectionViewCellDefaultStyle.DateTextStyle(font: font, color: TEXT_DARK)

        let baseStyle = BaseMessageCollectionViewCellAvatarStyle(colors: bubbleColors, bubbleBorderImages: nil, layoutConstants: BaseMessageCollectionViewCellDefaultStyle.createDefaultLayoutConstants(), dateTextStyle: dateSeparatorStyle, avatarStyle: avatarStyle)

        textMessagePresenter.textCellStyle = TextMessageCollectionViewCellDefaultStyle(bubbleImages: TextMessageCollectionViewCellDefaultStyle.createDefaultBubbleImages(), textStyle: textStyle, baseStyle: baseStyle)
        
        return [
            MessageType.TEXT.rawValue: [ textMessagePresenter ],
            TimeSeparatorModel.chatItemType: [TimeSeparatorPresenterBuilder()]
        ]
    }

    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items
    }

    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

    private func createPhotoInputItem() -> PhotosChatInputItem {
        let item = PhotosChatInputItem(presentingController: self)
        item.photoInputHandler = { [weak self] image in
            self?.dataSource.addPhotoMessage(image)
        }
        return item
    }
}
