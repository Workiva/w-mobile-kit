//
//  File.swift
//  WMobileKit

import Foundation
import SnapKit

public class WHyperlinkLabel: UILabel {
    public var links: [UIButton]?
    
    public override var text: String? {
        didSet {
            setupUI()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func setupUI() {
        
    }
    
    public func replaceRangeWithButton(range: NSRange) {
        
    }
}
