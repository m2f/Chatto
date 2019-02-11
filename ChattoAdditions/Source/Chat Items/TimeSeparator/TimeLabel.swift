
import UIKit

public class TimeLabel: UILabel {
    
    public var contentInset: UIEdgeInsets = UIEdgeInsets.zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
        self.textColor = UIColor.black
        self.backgroundColor = UIColor(red: 208/255, green: 233/255, blue: 245/255, alpha: 1)
        self.contentInset = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: contentInset))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override public var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + contentInset.left + contentInset.right
        let heigth = superContentSize.height + contentInset.top + contentInset.bottom
        return CGSize(width: width, height: heigth)
    }
    
    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + contentInset.left + contentInset.right
        let heigth = superSizeThatFits.height + contentInset.top + contentInset.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

