//
//  ViewController.swift
//  CMBottomGestureView
//
//  Created by CMJunghoon on 06/06/2020.
//  Copyright (c) 2020 CMJunghoon. All rights reserved.
//

import UIKit
import CMBottomGestureView

class ViewController: UIViewController {
  
  var bottom: CMBottomGestureView!
  let closeStatusView: UIView = {
    let view = UIView()
    view.backgroundColor = .blue
    return view
  }()
  
  let statusLabel: UILabel = {
    let label = UILabel()
    label.text = "Close"
    label.textColor = .white
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bottom = CMBottomGestureView(presentedView: view,
                                 maxHeight: 500,
                                 minHeight: 200,
                                 swipeDownType: .stayBottom)
    bottom.backgroundColor = .red
    bottom.delegate = self
    view.addSubview(bottom)
    
    bottom.addSubview(closeStatusView)
    closeStatusView.frame = bottom.bounds
    
    closeStatusView.addSubview(statusLabel)
    statusLabel.frame = CGRect(x: 20, y: 30, width: 300, height: 20);
  }
  
  override func viewWillLayoutSubviews() {
    bottom.roundCorners(corners: [.topLeft, .topRight], radius: 20)
  }
}

extension ViewController: CMBottomGestureDelegate {
  func didCompleteAnimation(view: UIView, position: CMDraggablePosition) {
    switch position {
    case .close:
      statusLabel.text = "Close"
      closeStatusView.isHidden = false
    case .open:
      closeStatusView.isHidden = true
    }
  }
}

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds,
                            byRoundingCorners: corners,
                            cornerRadii: CGSize(width: radius,
                                                height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }
}


