
import Chatto
import ChattoAdditions

public class Message: MessageModelProtocol {
    public dynamic var uid: String = ""
    public dynamic var type: ChatItemType = ""
    public dynamic var senderId: String = ""
    public dynamic var isIncoming: Bool
    public dynamic var date: Date
    public dynamic var status: Int32 = 0
    public dynamic var msgText: String = "" //may contain text or image url
    
    public var image: UIImage?
    
    init(msgId: String, msgType: String, senderId: String, isIncoming: Bool, date: Date, status: Int32, msgText: String) {
        self.uid = msgId
        self.type = msgType
        self.senderId = senderId
        self.isIncoming = isIncoming
        self.date = date
        self.status = status
        self.msgText = msgText
    }
}
