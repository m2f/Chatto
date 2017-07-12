
import Chatto
import ChattoAdditions

public class Message: MessageModelProtocol {
    public dynamic var msgId: String = ""
    public dynamic var msgType: ChatItemType
    public dynamic var senderId: String = ""
    public dynamic var isIncoming: Bool
    public dynamic var messagedOn: Date
    public dynamic var status: Int32 = 0
    public dynamic var msgText: String = "" //may contain text or image url
    
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
