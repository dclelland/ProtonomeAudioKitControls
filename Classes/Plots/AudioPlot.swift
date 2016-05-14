//
//  AudioPlot.swift
//  ProtonomeAudioKitControls
//
//  Created by Daniel Clelland on 5/12/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit
import AudioKit

@IBDesignable public class AudioPlot: UIControl {
    
    public enum Mode {
        case Normal
        case Highlighted
        case Selected
    }
    
    public var mode: Mode = .Normal
    
    public var hue: CGFloat = 0.0
    public var saturation: CGFloat = 0.0
    
    private var csound: CsoundObj?
    
    private var data = NSData()
    private var samples = [Float]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    deinit {
        AKManager.removeBinding(self)
    }
    
    // MARK: - Overrides
    
    override public var selected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if (superview == nil) {
            AKManager.removeBinding(self)
        } else {
            AKManager.addBinding(self)
        }
    }
    
    override public func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        CGContextClearRect(context, rect)
        
        CGContextSetFillColorWithColor(context, backgroundPathColor.CGColor)
        backgroundPath.fill()
        backgroundPath.addClip()
        
        CGContextSetFillColorWithColor(context, foregroundPathColor.CGColor)
        foregroundPath.fill()
    }
    
    // MARK: - Private getters
    
    private var backgroundPath: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius)
    }
    
    private var foregroundPath: UIBezierPath {
        let path = CGPathCreateMutable()
        
        let length = samples.count / 2
        
        for i in 0..<length {
            let sample = CGFloat(samples[i * 2])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) * (bounds.width / CGFloat(length - 1))
            let y = (safeSample + 0.5) * bounds.height
            
            if (i == 0) {
                CGPathMoveToPoint(path, nil, x, y)
            } else {
                CGPathAddLineToPoint(path, nil, x, y)
            }
        }
        
        for i in (0..<length).reverse() {
            let sample = CGFloat(samples[i * 2 + 1])
            let safeSample = sample.isNaN ? 0.0 : sample
            
            let x = CGFloat(i) * (bounds.width / CGFloat(length - 1))
            let y = (-safeSample + 0.5) * bounds.height
            
            CGPathAddLineToPoint(path, nil, x, y)
        }
        
        if length > 0 {
            CGPathCloseSubpath(path)
        }
        
        return UIBezierPath(CGPath: path)
    }
    
    private var backgroundPathColor: UIColor {
        switch mode {
        case .Normal:
            return UIColor.protonome_darkGreyColor()
        case .Highlighted:
            return UIColor.protonome_mediumColor(withHue: hue, saturation: saturation)
        case .Selected:
            return UIColor.protonome_darkColor(withHue: hue, saturation: saturation)
        }
    }
    
    private var foregroundPathColor: UIColor {
        return UIColor.protonome_lightColor(withHue: hue, saturation: saturation)
    }
    
}

extension AudioPlot: CsoundBinding {
    
    public func setup(csoundObj: CsoundObj) {
        csound = csoundObj
    }
    
    public func updateValuesFromCsound() {
        guard let csound = csound else {
            return
        }
        
        data = csound.getOutSamples()
        
        var samples = [Float](count: data.length / sizeof(Float), repeatedValue: 0)
        
        data.getBytes(&samples, length:data.length)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.samples = samples
        })
    }
    
}
