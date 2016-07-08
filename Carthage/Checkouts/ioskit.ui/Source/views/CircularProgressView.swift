//
//  CircularProgressView.swift
//  PosseKit
//
//  Created by Posse in NYC
//  http://goposse.com
//
//  Copyright (c) 2016 Posse Productions LLC.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//  * Neither the name of the Posse Productions LLC, Posse nor the
//    names of its contributors may be used to endorse or promote products
//    derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL POSSE PRODUCTIONS LLC (POSSE) BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import UIKit
import KitCore

public class CircularProgressView : UIView {
  
  // state
  private (set) public var isAnimating: Bool = false
  private var progress: Double = 1.0
  
  // styling
  public var lineWidth: Double = 1.0 {
    didSet {
      self.configureTrackLayer()
      self.configureProgressLayer()
    }
  }
  
  public var progressColor: UIColor = UIColor(hex: 0x666666) {
    didSet {
      self.configureProgressLayer()
    }
  }
  
  public var trackColor: UIColor = UIColor(white: 1.0, alpha: 0.15) {
    didSet {
      self.configureTrackLayer()
    }
  }

  // animation properties
  public var progressAnimationDuration: NSTimeInterval = 0.65
  public var spinnerAnimationDuration: NSTimeInterval = 0.85
  public var spinnerTimingFunction: String = kCAMediaTimingFunctionLinear

  lazy private var strokeStartAnimation: CABasicAnimation = {
    var animation: CABasicAnimation = self.animationWithKeyPath("strokeStart")
    animation.duration = self.progressAnimationDuration
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.repeatCount = 1
    animation.fillMode = kCAFillModeBackwards
    animation.removedOnCompletion = true
    return animation
  }()

  lazy private var strokeEndAnimation: CABasicAnimation = {
    var animation: CABasicAnimation = self.animationWithKeyPath("strokeEnd")
    animation.duration = self.progressAnimationDuration
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    animation.repeatCount = 1
    animation.fillMode = kCAFillModeBackwards
    animation.removedOnCompletion = true
    return animation
  }()
  
  
  // MARK: - Initialization
  public convenience init(frame: CGRect, lineWidth: Double, progressColor: UIColor) {
    self.init(frame: frame)
    self.lineWidth = lineWidth
    self.progressColor = progressColor
  }
  
  public convenience required init?(coder aDecoder: NSCoder) {
    self.init(frame: CGRectZero, lineWidth: 0.0, progressColor: UIColor.blackColor())
  }  
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.addSublayer(self.trackLayer)
    self.trackLayer.addSublayer(self.progressLayer)
    self.backgroundColor = UIColor.clearColor()
  }
  
  
  // MARK: - Lazy initialization
  private lazy var progressLayer: CAShapeLayer = {
    return CAShapeLayer()
  }()

  private lazy var trackLayer: CAShapeLayer = {
    return CAShapeLayer()
  }()

  
  // MARK: - Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    self.configureTrackLayer()
    self.configureProgressLayer()
  }
  
  
  // MARK: - Setters
  public func setProgress(progress progress: Double, animated: Bool) {
    setProgress(progress: progress, animated: animated, completion: nil)
  }
  
  public func setProgress(progress progress: Double, animated: Bool, completion: (() -> (Void))?) {

    if self.progress == progress {
      return
    }

    self.configureTrackLayer(at: 0.0)
    self.configureProgressLayer(at: 1.0)

    if animated {
      CATransaction.begin()
      CATransaction.setCompletionBlock({
        self.configureTrackLayer(at: progress)
        self.configureProgressLayer()
        if completion != nil {
          completion!()
        }
      })

      self.strokeStartAnimation.fromValue = self.progress
      self.strokeStartAnimation.toValue = progress
      self.strokeEndAnimation.fromValue = self.progress
      self.strokeEndAnimation.toValue = progress
      
      self.trackLayer.addAnimation(self.strokeStartAnimation, forKey: self.strokeStartAnimation.keyPath)
      self.progressLayer.addAnimation(self.strokeEndAnimation, forKey: self.strokeEndAnimation.keyPath)
      
      self.progress = progress
      
      CATransaction.commit()
    } else {
      self.progress = progress
      self.configureTrackLayer(at: progress)
      self.configureProgressLayer()
    }
  }
  
  
  // MARK: - Progress layer configuration
  internal func configureTrackLayer() {
    configureTrackLayer(at: 0.0)
  }
  
  internal func configureTrackLayer(at progress: Double) {
    if let layer: CAShapeLayer = self.trackLayer {
      layer.path = pathForTrack(at: progress).CGPath
      layer.frame = self.bounds
      layer.fillColor = UIColor.clearColor().CGColor
      layer.lineWidth = CGFloat(self.lineWidth)
      layer.strokeColor = self.trackColor.CGColor
      layer.backgroundColor = UIColor.clearColor().CGColor
    }
  }
  
  internal func configureProgressLayer() {
    configureProgressLayer(at: self.progress)
  }
  
  internal func configureProgressLayer(at progress: Double) {
    if let layer: CAShapeLayer = self.progressLayer {
      layer.path = pathForProgressAmount(progress).CGPath
      layer.frame = self.bounds
      layer.fillColor = UIColor.clearColor().CGColor
      layer.lineWidth = CGFloat(self.lineWidth)
      layer.strokeColor = self.progressColor.CGColor
      layer.backgroundColor = UIColor.clearColor().CGColor
    }
  }
  
  internal func pathForTrack(at progress: Double) -> UIBezierPath {
    let center: CGPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    let radius: CGFloat = fmin(CGRectGetWidth(self.bounds),
                               CGRectGetHeight(self.bounds)) / 2.0 - (CGFloat(self.lineWidth) / 2.0);
    var startAngle: CGFloat = CGFloat(DegreesToRadians((progress * 360.0) - 90.0))
    if isAnimating {
      startAngle = CGFloat(DegreesToRadians(240.0))
    }
    let endAngle: CGFloat = CGFloat(DegreesToRadians(270.0))
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle,
                        endAngle: endAngle, clockwise: true)
  }
  
  internal func pathForProgressAmount(progress: Double) -> UIBezierPath {
    let center: CGPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    let radius: CGFloat = fmin(CGRectGetWidth(self.bounds),
                               CGRectGetHeight(self.bounds)) / 2.0 - (CGFloat(self.lineWidth) / 2.0);
    let startAngle: CGFloat = CGFloat(DegreesToRadians(-90.0))
    var endAngle: CGFloat = CGFloat(DegreesToRadians(240.0))
    if !isAnimating {
      endAngle = CGFloat(DegreesToRadians((progress * 360.0) - 90.0))
    }
    return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle,
                        endAngle: endAngle, clockwise: true)
  }
  
  
  // MARK: - Animation
  private func attachRotationAnimation() {
    let animation = self.animationWithKeyPath("transform.rotation.z")
    animation.toValue = 0.0
    animation.byValue = 2 * M_PI
    animation.timingFunction = CAMediaTimingFunction(name: self.spinnerTimingFunction)
    animation.duration = self.spinnerAnimationDuration
    animation.repeatCount = Float.infinity
    animation.removedOnCompletion = false
    self.trackLayer.addAnimation(animation, forKey: animation.keyPath)
  }
  
  private func animationWithKeyPath(keyPath: String) -> CABasicAnimation {
    let animation: CABasicAnimation = CABasicAnimation(keyPath:keyPath)
    animation.autoreverses = false
    return animation
  }
  
  public func startAnimating(restart restart: Bool) {
    self.trackLayer.removeAllAnimations()
    self.progressLayer.removeAllAnimations()
    self.setProgress(progress: 0.95, animated: true)
    self.isAnimating = true
    self.attachRotationAnimation()
  }
  
  public func stopAnimating() {
    self.isAnimating = false
    self.trackLayer.removeAllAnimations()
    self.progressLayer.removeAllAnimations()
  }

}