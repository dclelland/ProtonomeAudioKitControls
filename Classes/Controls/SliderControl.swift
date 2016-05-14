//
//  SliderControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Lerp

@IBDesignable public class SliderControl: ParameterControl {
    
    // MARK: - Properties
    
    override public var value: Float {
        didSet {
            valueLabel.text = formattedValue
        }
    }
    
    override public var font: UIFont {
        didSet {
            valueLabel.font = font
        }
    }
    
    // MARK: - Views
    
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.protonome_blackColor()
        return label
    }()
    
    // MARK: - Overrides
    
    override public func updateConstraints() {
        super.updateConstraints()
        
        addSubview(valueLabel)
        valueLabel.snp_updateConstraints { make in
            make.top.equalTo(self.snp_topMargin)
            make.left.equalTo(self.snp_leftMargin)
            make.right.equalTo(self.snp_rightMargin)
            make.height.equalTo(valueLabel.snp_width).multipliedBy(0.75)
        }
    }
    
    // MARK: - Overrideables
    
    private var internalPosition: CGPoint = CGPoint.zero
    
    override func ratio(forLocation location: CGPoint) -> Float {
        // this could far more easily be done with pattern matching...
        if (bounds.contains(location)) {
            internalPosition = location
            let ratio = location.y.ilerp(min: bounds.maxY, max: bounds.minY)
            return Float(ratio).clamp(min: 0.0, max: 1.0)
        } else {
            let scale = max(bounds.minX - location.x, 0.0) + max(location.x - bounds.maxX, 0.0)
            let offset = internalPosition.y.ilerp(min: bounds.maxY, max: bounds.minY)
            let ratio = location.y.ilerp(min: bounds.maxY + scale * offset, max: bounds.minY - scale * (1.0 - offset))
            return Float(ratio).clamp(min: 0.0, max: 1.0)
        }
    }
    
    override func path(forRatio ratio: Float) -> UIBezierPath {
        let x = bounds.minX
        let y = bounds.minY + bounds.height * (1.0 - CGFloat(ratio))
        let width = bounds.width
        let height = bounds.height * CGFloat(ratio)
        
        return UIBezierPath(rect: CGRect(x: x, y: y, width: width, height: height))
    }
    
}
