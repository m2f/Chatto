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

public protocol MessageViewModelProtocol: class { // why class? https://gist.github.com/diegosanchezr/29979d22c995b4180830
    var isIncoming: Bool { get }
    var showsTail: Bool { get set }
    var date: String { get }
    var status: Int32 { get }
    var statusImage: UIImage? { set get }
    var avatarImage: Observable<UIImage?> { set get }
    func willBeShown() // Optional
    func wasHidden() // Optional
}

extension MessageViewModelProtocol {
    public func willBeShown() {}
    public func wasHidden() {}
}

public protocol DecoratedMessageViewModelProtocol: MessageViewModelProtocol {
    var messageViewModel: MessageViewModelProtocol { get }
}

extension DecoratedMessageViewModelProtocol {
    public var isIncoming: Bool {
        return self.messageViewModel.isIncoming
    }
    public var showsTail: Bool {
        get {
            return self.messageViewModel.showsTail
        }
        set {
            self.messageViewModel.showsTail = newValue
        }
    }
    public var date: String {
        return self.messageViewModel.date
    }

    public var status: Int32 {
        return self.messageViewModel.status
    }
    
    public var statusImage: UIImage? {
        get {
            return self.messageViewModel.statusImage
        }
        set {
            self.messageViewModel.statusImage = newValue
        }
    }

    public var avatarImage: Observable<UIImage?> {
        get {
            return self.messageViewModel.avatarImage
        }
        set {
            self.messageViewModel.avatarImage = newValue
        }
    }
}

open class MessageViewModel: MessageViewModelProtocol {
    
    open var isIncoming: Bool {
        return self.messageModel.isIncoming
    }

    open var status: Int32 {
        return self.messageModel.status
    }
    
    public var statusImage: UIImage?

    open var showsTail: Bool
    open lazy var date: String = {
        return self.dateFormatter.string(from: self.messageModel.date as Date)
    }()

    public let dateFormatter: DateFormatter
    public private(set) var messageModel: MessageModelProtocol

    public init(dateFormatter: DateFormatter, showsTail: Bool, messageModel: MessageModelProtocol, avatarImage: UIImage?) {
        self.dateFormatter = dateFormatter
        self.showsTail = showsTail
        self.messageModel = messageModel
        self.avatarImage = Observable<UIImage?>(avatarImage)
    }
    
    public var avatarImage: Observable<UIImage?>
}

public class MessageViewModelDefaultBuilder {

    public init() {}

    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    public func createMessageViewModel(_ message: MessageModelProtocol) -> MessageViewModelProtocol {
        // Override to use default avatarImage
        return MessageViewModel(dateFormatter: MessageViewModelDefaultBuilder.dateFormatter, showsTail: false, messageModel: message, avatarImage: nil)
    }
}
