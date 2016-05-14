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
    
    // MARK: - Views
    
    public lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        label.textColor = UIColor.protonome_blackColor()
        return label
    }()
    
    // MARK: - Overrides
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        valueLabel.text = formatter.string(forValue: value)
        valueLabel.font = font
    }
    
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
    
    private var exitRatio: CGFloat = 0.0
    
    override func ratio(forLocation location: CGPoint) -> Float {
        switch location.x {
        case (-.max)..<bounds.minX:
            let scale = bounds.minX - location.x
            let min = bounds.maxY + scale * exitRatio
            let max = bounds.minY - scale * (1.0 - exitRatio)
            let ratio = location.y.ilerp(min: min, max: max).clamp(min: 0.0, max: 1.0)
            return Float(ratio)
        case bounds.minX...bounds.maxX:
            let min = bounds.maxY
            let max = bounds.minY
            let ratio = location.y.ilerp(min: min, max: max).clamp(min: 0.0, max: 1.0)
            exitRatio = ratio
            return Float(ratio)
        default:
            let scale = location.x - bounds.maxX
            let min = bounds.maxY + scale * exitRatio
            let max = bounds.minY - scale * (1.0 - exitRatio)
            let ratio = location.y.ilerp(min: min, max: max)
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
