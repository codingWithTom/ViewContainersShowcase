//
//  GridViewController.swift
//  ViewContainersShowcase
//
//  Created by Tomas Trujillo on 2020-08-25.
//  Copyright © 2020 CodingWithTom. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
  
  @IBOutlet private weak var compressButton: UIButton!
  @IBOutlet private weak var containerView: UIView!
  private var viewControllers: [UIViewController] = []
  private weak var selectedViewController: UIViewController? {
    didSet {
      compressButton.isHidden = selectedViewController == nil
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    selectedViewController = nil
    setupControllers()
    addViews()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard selectedViewController == nil, let firstTouch = touches.first else { return }
    let selectedController = viewControllers.first(where: { $0.view.hitTest(firstTouch.location(in: $0.view), with: event) != nil })
    self.selectedViewController = selectedController
    presentSelectedController()
  }
  
  @IBAction func tappedCompressedView(_ sender: Any) {
    guard let view = selectedViewController?.view else { return }
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear,
                   animations: {
                    view.transform = .identity
    }, completion:  nil)
    selectedViewController = nil
  }
  
}

private extension GridViewController {
  func setupControllers() {
    let blueController = UIViewController()
    blueController.view.backgroundColor = .blue
    let redController = UIViewController()
    redController.view.backgroundColor = .red
    let yellowController = UIViewController()
    yellowController.view.backgroundColor = .yellow
    let brownController = UIViewController()
    brownController.view.backgroundColor = .brown
    viewControllers = [
      blueController, redController, yellowController, brownController
    ]
  }
  
  func addViews() {
    addView(viewControllers[0].view, xMultipler: 0.5, yMultiplier: 0.5) // Upper left
    addView(viewControllers[1].view, xMultipler: 1.5, yMultiplier: 0.5) // Upper right
    addView(viewControllers[2].view, xMultipler: 0.5, yMultiplier: 1.5) // Lower left
    addView(viewControllers[3].view, xMultipler: 1.5, yMultiplier: 1.5) // Lower right
    viewControllers.forEach { controller in
      controller.removeFromParent()
      self.addChild(controller)
      controller.didMove(toParent: self)
    }
  }
  
  func addView(_ view: UIView, xMultipler: CGFloat, yMultiplier: CGFloat) {
    containerView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: xMultipler, constant: 0.0),
      NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: yMultiplier, constant: 0.0),
      view.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5),
      view.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.5)
    ])
  }
  
  func presentSelectedController() {
    guard let view = selectedViewController?.view else { return }
    containerView.bringSubviewToFront(view)
    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
      var viewTransform = view.transform
      viewTransform = CGAffineTransform(translationX: self.containerView.bounds.midX - view.frame.midX,
                                        y: self.containerView.bounds.midY - view.frame.midY)
      viewTransform = viewTransform.scaledBy(x: 2.0, y: 2.0)
      view.transform = viewTransform
    }, completion: nil)
  }
}
