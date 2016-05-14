//
//  PickerControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

@IBDesignable public class PickerControl: ParameterControl {
    
    // MARK: - Properties
    
    @IBInspectable public var gridColumns: UInt = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var gridRows: UInt = 0 {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    @IBInspectable public var gutter: CGFloat = 2.0 {
        didSet {
            setNeedsUpdateConstraints()
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Views
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.userInteractionEnabled = false
        return view
    }()
    
    // MARK: - Overrides
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(containerView)
        containerView.snp_updateConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.bottom.equalTo(titleLabel.snp_top).offset(-gutter)
        }
    }
    
    // MARK: - Overrideables
    
    override func ratio(forLocation location: CGPoint) -> Float {
        return 0.0
    }
    
    override func path(forRatio ratio: Float) -> UIBezierPath {
        return UIBezierPath()
    }
    
}
