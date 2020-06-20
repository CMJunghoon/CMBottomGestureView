//
//  CMBottomGesutureView.swift
//  CMBottomGestureView
//
//  Created by vash jung on 2020/06/06.
//

import UIKit

public enum CMSwipeDownType {
  case stayBottom
  case dismiss
}

enum CMDragDirection {
  case up
  case down
}

public enum CMDraggablePosition {
  case open
  case close
  
  internal var dimAlpha: CGFloat {
    switch self {
    case .close: return 0.0
    case .open: return 0.45
    }
  }
  
  internal func nextPostion(for dragDirection: CMDragDirection) -> CMDraggablePosition {
    switch (self, dragDirection) {
    case (.close, .up): return .open
    case (.close, .down): return .close
    case (.open, .up): return .open
    case (.open, .down): return .close
    }
  }
}

public protocol CMBottomGestureDelegate: class {
  func didCompleteAnimation(view: UIView, position: CMDraggablePosition)
}

public class CMBottomGestureView: UIView {
  private var dimmingView = UIView()
  var position: CMDraggablePosition = .close
  var dragDirection: CMDragDirection = .up
  let swipeDownType: CMSwipeDownType
  
  private let animateSpaceView = UIView()
  private var animator: UIViewPropertyAnimator?
  private let springTiming = UISpringTimingParameters(dampingRatio: 0.7,
                                                      initialVelocity: CGVector(dx: 0, dy: 10))
  private var presentedView: UIView
  private let maxHeight: CGFloat
  private let minHeight: CGFloat
  
  public override var backgroundColor: UIColor? {
    didSet {
      updateBackgroudColor()
    }
  }
  
  public weak var delegate: CMBottomGestureDelegate?
  
  public init(presentedView: UIView,
              maxHeight: CGFloat,
              minHeight: CGFloat,
              swipeDownType: CMSwipeDownType) {
    self.presentedView = presentedView
    self.maxHeight = maxHeight
    self.minHeight = minHeight
    self.swipeDownType = swipeDownType
    let frame = CGRect(x: 0,
                       y: UIScreen.main.bounds.size.height - minHeight,
                       width: UIScreen.main.bounds.size.width,
                       height: maxHeight)
    super.init(frame: frame)
    
    animateSpaceView.frame = CGRect(x: 0,
                                    y: frame.size.height,
                                    width: frame.size.width,
                                    height: 20)
    self.addSubview(animateSpaceView)
    
    dimmingView.alpha = 0
    dimmingView.backgroundColor = .black
    dimmingView.frame = UIScreen.main.bounds
    
    animator = UIViewPropertyAnimator(duration: 0.6, timingParameters: springTiming)
    animator?.isInterruptible = false
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(panRecognizer:)))
    panGesture.cancelsTouchesInView = false
    addGestureRecognizer(panGesture)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func originY(_ drPosition: CMDraggablePosition) -> CGFloat {
    let height = drPosition == .open ? maxHeight : minHeight
    return UIScreen.main.bounds.height - height
  }
  
  func boundary(_ drPosition: CMDraggablePosition) -> CGFloat {
    let height = drPosition == .open ? maxHeight : minHeight
    return height * 0.9
  }
  
  func updateBackgroudColor() {
    animateSpaceView.backgroundColor = backgroundColor
  }
  
  @objc func userDidPan(panRecognizer: UIPanGestureRecognizer) {
    let translationPoint = panRecognizer.translation(in: self)
    let velocity = panRecognizer.velocity(in: self)
    let currentOriginY = originY(position)
    let newOffset = currentOriginY + translationPoint.y
    
    dimmingView.alpha = dimmingAlpha(newOffset, currentOriginY)
    
    if panRecognizer.state == .ended {
      if velocity.y < -200 {
        animate(to: position.nextPostion(for: .up))
      } else if velocity.y > 200 {
        switch swipeDownType {
        case .stayBottom:
          animate(to: position.nextPostion(for: .down))
        case .dismiss:
          dismiss()
        }
      } else {
        animate(newOffset)
      }
    }
  }
}

extension CMBottomGestureView {
  func dimmingAlpha(_ newOffset: CGFloat, _ currentOriginY: CGFloat) -> CGFloat {
    dragDirection = newOffset > currentOriginY ? .down : .up
    
    let canDragInProposedDirection = dragDirection == .up && position == .open ? false : true
    
    if canDragInProposedDirection {
      if position == .close {
        if UIScreen.main.bounds.height - maxHeight <= newOffset {
          frame.origin.y = newOffset
        }
      } else {
        frame.origin.y = newOffset
      }
      
      let nextOriginY = originY(position.nextPostion(for: dragDirection))
      let area = dragDirection == .up ? frame.origin.y - UIScreen.main.bounds.origin.y : -(frame.origin.y - nextOriginY)
      if newOffset != area && position == .open || position.nextPostion(for: dragDirection) == .open {
        let onePercent = area / 100
        let percentage = (area-newOffset) / onePercent / 100
        return min(0, percentage * CMDraggablePosition.open.dimAlpha)
      }
    }
    
    return 0
  }
}

extension CMBottomGestureView {
  func animate(_ dragOffset: CGFloat) {
    let distanceFromBottom = UIScreen.main.bounds.height - dragOffset
    if distanceFromBottom > boundary(position) {
      animate(to: .open)
      position = .open
    } else {
      switch swipeDownType {
      case .stayBottom:
        animate(to: .close)
      case .dismiss:
        dismiss()
      }
      position = .close
    }
  }
  
  func animate(to position: CMDraggablePosition) {
    guard let animator = animator else { return }
    animator.addAnimations { [weak self] in
      self?.frame.origin.y = self?.originY(position) ?? 0
      self?.dimmingView.alpha = position.dimAlpha
    }
    
    dimmingView.removeFromSuperview()
    if position == .open {
      dimmingView = UIView()
      dimmingView.alpha = position.dimAlpha
      dimmingView.backgroundColor = .black
      dimmingView.frame = UIScreen.main.bounds
      presentedView.insertSubview(dimmingView, belowSubview: self)
    }
    
    self.position = position
    animator.startAnimation()
    
    self.delegate?.didCompleteAnimation(view: self, position: self.position)
  }
  
  func dismiss() {
    guard let animator = animator else { return }
    animator.addAnimations { [weak self] in
      self?.frame.origin.y = UIScreen.main.bounds.height
    }
    
    dimmingView.removeFromSuperview()
    animator.startAnimation()
    
    animator.addCompletion { [weak self] (position) in
      if position == .end {
        self?.removeFromSuperview()
      }
    }
  }
}
