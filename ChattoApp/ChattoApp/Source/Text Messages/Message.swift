
import Chatto
import ChattoAdditions

public class Message: MessageModelProtocol {
    @objc public dynamic var msgId: String = ""
    @objc public dynamic var msgType: ChatItemType
    @objc public dynamic var senderId: String = ""
    @objc public dynamic var isIncoming: Bool
    @objc public dynamic var messagedOn: Date
    @objc public dynamic var status: Int32 = 0
    @objc public dynamic var msgText: String = "" //may contain text or image url
    
    public var image: UIImage?
    
    init(msgId: String, msgType: ChatItemType, senderId: String, isIncoming: Bool, date: Date, status: Int32, msgText: String) {
        self.msgId = msgId
        self.msgType = msgType
        self.senderId = senderId
        self.isIncoming = isIncoming
        self.messagedOn = date
        self.status = status
        self.msgText = msgText
    }
}
