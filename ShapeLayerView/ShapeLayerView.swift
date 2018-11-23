//
//  ShapeLayerView.swift
//  ShapeLayerView
//
//  Created by Yasuhiro Inami on 2017-11-12.
//  Copyright © 2017 Yasuhiro Inami. All rights reserved.
//

import UIKit

/// CAShapeLayer subclass with its animatable `path` synchronizing with UIKit-internal animations,
/// e.g. orientation change.
///
/// - SeeAlso:
///   - https://gist.github.com/nicklockwood/d374033b27c62662ac8d
///   - https://stackoverflow.com/questions/24936987/animate-cashapelayer-path-on-animated-bounds-change
///   - https://stackoverflow.com/questions/35713244/circular-round-uiview-resizing-with-autolayout-how-to-animate-cornerradius
open class ShapeLayer: CAShapeLayer
{
    open override func action(forKey event: String) -> CAAction?
    {
        if event == "path" {
            if let action = action(forKey: "backgroundColor") as? CABasicAnimation {
                let animation = CABasicAnimation(keyPath: event)
                animation.fromValue = self.path

                // Copy values from existing action.
                animation.autoreverses = action.autoreverses
                animation.beginTime = action.beginTime
                animation.delegate = action.delegate
                animation.duration = action.duration
                animation.fillMode = action.fillMode
                animation.repeatCount = action.repeatCount
                animation.repeatDuration = action.repeatDuration
                animation.speed = action.speed
                animation.timingFunction = action.timingFunction
                animation.timeOffset = action.timeOffset

                return animation
            }
        }

        return super.action(forKey: event)
    }
}

// MARK: iOS / tvOS

#if os(iOS) || os(tvOS)

/// CAShapeLayer-backed UIView subclass that synchronizes with UIKit-internal animations,
/// e.g. orientation change.
open class ShapeLayerView: UIView
{
    open override class var layerClass: Swift.AnyClass
    {
        return ShapeLayer.self
    }

    open override var layer: CAShapeLayer
    {
        return super.layer as! CAShapeLayer
    }

    /// UIView-animatable.
    open var path: UIBezierPath?
    {
        get {
            return self.layer.path.map(UIBezierPath.init)
        }
        set {
            self.layer.path = newValue?.cgPath
        }
    }
}

/// UIView subclass with animatable `maskPath` that is masked by `ShapeLayerView`.
open class ShapeMaskedView: UIView
{
    private let _maskView = ShapeLayerView()

    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        self._init()
    }

    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self._init()
    }

    private func _init()
    {
        self._maskView.layer.fillRule = kCAFillRuleEvenOdd
        self._maskView.layer.fillColor = UIColor.black.cgColor

        let maskPath = UIBezierPath(rect: self.bounds)
        _maskView.layer.path = maskPath.cgPath

        self.mask = self._maskView
    }

    /// UIView-animatable.
    open var maskPath: UIBezierPath?
    {
        get {
            return self._maskView.path
        }
        set {
            self._maskView.path = newValue
        }
    }
}

#endif
