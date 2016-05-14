//
//  DialControl.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import Bezzy
import Degrad
import Lerp
import SnapKit

@IBDesignable public class DialControl: ParameterControl {
    
    // MARK: - Constants
    
    private let dialRadius: Float = 0.375
    
    private let minimumAngle: Float = 45°
    private let maximumAngle: Float = 315°
    
    private let minimumDeadZone: Float = 2°
    private let maximumDeadZone: Float = 358°
    
    // MARK: - Properties
    
    override public var value: Float {
        didSet {
            valueLabel.text = formatter.string(forValue: value)
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
            make.bottom.equalTo(titleLabel.snp_top)
        }
    }
    
    // MARK: - Overrideables
    
    override func ratio(forLocation location: CGPoint) -> Float {
        let center = valueLabel.center
        let radius = dialRadius * Float(min(valueLabel.frame.height, valueLabel.frame.width))
        
        let distance = Float(hypot(location.y - center.y, location.x - center.x))
        let angle = Float(atan2(location.y - center.y, location.x - center.x))
        
        guard radius < distance else {
            return scale.ratio(forValue: value)
        }
        
        let scaledAngle = fmod(angle + 270°, 360°)
        
        guard (minimumDeadZone...maximumDeadZone).contains(scaledAngle) else {
            return scale.ratio(forValue: value)
        }
        
        return scaledAngle.ilerp(min: minimumAngle, max: maximumAngle).clamp(min: 0.0, max: 1.0)
    }
    
    override func path(forRatio ratio: Float) -> UIBezierPath {
        let center = valueLabel.center
        
        let radius = CGFloat(dialRadius) * min(valueLabel.frame.height, valueLabel.frame.width)
        let angle = CGFloat(ratio.lerp(min: minimumAngle, max: maximumAngle) + 90°)
        
        let pointerA = pol2rec(r: radius * 0.75, θ: angle - 45°)
        let pointerB = pol2rec(r: radius * 1.25, θ: angle)
        let pointerC = pol2rec(r: radius * 0.75, θ: angle + 45°)
        
        return UIBezierPath.makePath { make in
            make.oval(at: center, radius: radius)
            make.move(x: center.x + pointerA.x, y: center.y + pointerA.y)
            make.line(x: center.x + pointerB.x, y: center.y + pointerB.y)
            make.line(x: center.x + pointerC.x, y: center.y + pointerC.y)
            make.close()
        }
    }
    
}
