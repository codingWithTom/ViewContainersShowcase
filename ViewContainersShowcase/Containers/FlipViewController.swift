//
//  FlipViewController.swift
//  ViewContainersShowcase
//
//  Created by Tomas Trujillo on 2020-08-25.
//  Copyright © 2020 CodingWithTom. All rights reserved.
//

import UIKit

class FlipViewController: UIViewController {
  
  @IBOutlet private weak var containerView: UIView!
  var frontViewController: UIViewController?
  var backViewController: UIViewController?
  private var isShowingFront = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let blueViewController = UIViewController()
    blueViewController.view.backgroundColor = .blue
    let redViewController = UIViewController()
    redViewController.view.backgroundColor = .red
    frontViewController = blueViewController
    backViewController = redViewController
    showViewController(frontViewController)
    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedContainerView))
    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedContainerView))
    leftSwipeGesture.direction = .left
    containerView.addGestureRecognizer(rightSwipeGesture)
    containerView.addGestureRecognizer(leftSwipeGesture)
  }
  
  @objc
  func swipedContainerView(swipeGesture: UISwipeGestureRecognizer) {
    isShowingFront.toggle()
    UIView.transition(with: containerView, duration: 1.0,
                      options: swipeGesture.direction == .left ? .transitionFlipFromRight : .transitionFlipFromLeft,
                      animations: {
      self.showViewController(self.isShowingFront ? self.frontViewController : self.backViewController)
    }, completion: nil)
  }
}

private extension FlipViewController {
  func showViewController(_ viewController: UIViewController?) {
    guard let controller = viewController else { return }
    containerView.subviews.forEach { $0.removeFromSuperview() }
    controller.removeFromParent()
    self.addChild(controller)
    containerView.addSubview(controller.view)
    // Constrain view
    controller.didMove(toParent: self)
  }
  
  func constrainViewToContainer(controllerView: UIView) {
    controllerView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      controllerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
      controllerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
      controllerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
      controllerView.topAnchor.constraint(equalTo: containerView.topAnchor)
    ])
  }
}
