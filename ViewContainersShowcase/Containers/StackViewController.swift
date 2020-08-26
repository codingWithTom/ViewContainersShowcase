//
//  StackViewController.swift
//  ViewContainersShowcase
//
//  Created by Tomas Trujillo on 2020-08-25.
//  Copyright © 2020 CodingWithTom. All rights reserved.
//

import UIKit

class StackViewController: UIViewController {
  
  @IBOutlet private weak var containerView: UIView!
  private var viewControllers: [UIViewController] = []
  private let visibleCardStackHeight: CGFloat = 30.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let redController = UIViewController()
    redController.view.backgroundColor = .red
    let blueController = UIViewController()
    blueController.view.backgroundColor = .blue
    let yellowController = UIViewController()
    yellowController.view.backgroundColor = .yellow
    let greenController = UIViewController()
    greenController.view.backgroundColor = .green
    let purpleController = UIViewController()
    purpleController.view.backgroundColor = .purple
    viewControllers = [
      purpleController,
      greenController,
      yellowController,
      blueController,
      redController
    ]
    setupStack()
    setupGestures()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    if let (index, _) = viewControllers.enumerated().first(where: { $1.view.hitTest(touch.location(in: $1.view), with: event) != nil }) {
      guard index != 0 else { return }
      bringControllerToFront(at: index)
    }
  }
}

private extension StackViewController {
  func setupStack() {
    viewControllers.forEach { controller in
      addController(controller)
    }
    setupOffsets()
  }
  
  func addController(_ controller: UIViewController) {
    controller.removeFromParent()
    self.addChild(controller)
    containerView.insertSubview(controller.view, at: 0)
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    controller.view.layer.cornerRadius = 20.0
    NSLayoutConstraint.activate([
      controller.view.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.8),
      controller.view.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.8),
      controller.view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      controller.view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
    ])
    controller.didMove(toParent: self)
  }
  
  func setupOffsets() {
    let startingLowerPoint = CGFloat(viewControllers.count / 2) * visibleCardStackHeight
    viewControllers.enumerated().forEach { index, controller in
      controller.view.transform = CGAffineTransform(translationX: 0.0, y: startingLowerPoint - CGFloat(index) * visibleCardStackHeight)
    }
  }
  
  func setupGestures() {
    guard let firstController = viewControllers.first else { return }
    let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedFrontController))
    leftSwipeGesture.direction = .left
    let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedFrontController))
    firstController.view.addGestureRecognizer(leftSwipeGesture)
    firstController.view.addGestureRecognizer(rightSwipeGesture)
  }
  
  func removeGestures() {
    viewControllers.forEach { controller in
      controller.view.gestureRecognizers?.forEach { controller.view.removeGestureRecognizer($0) }
    }
  }
  
  @objc
  func swipedFrontController(swipeGesture: UISwipeGestureRecognizer) {
    let firstController = viewControllers.removeFirst()
    let displacement: CGFloat = swipeGesture.direction == .left ? -200 : 200
    removeGestures()
    UIView.animate(withDuration: 0.25, animations: {
      firstController.view.transform = CGAffineTransform(translationX: displacement, y: 0.0)
      self.setupOffsets()
    }) { _ in
      self.containerView.insertSubview(firstController.view, at: 0)
    }
    UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveEaseOut, animations: {
      let lastViewTransform = self.viewControllers.last?.view.transform ?? .identity
      firstController.view.transform = lastViewTransform.translatedBy(x: 0, y: -self.visibleCardStackHeight)
    }) { _ in
      self.viewControllers.append(firstController)
      self.setupGestures()
    }
  }
  
  func bringControllerToFront(at index: Int) {
    let controller = viewControllers.remove(at: index)
    UIView.animate(withDuration: 0.2, animations: {
      controller.view.transform = CGAffineTransform(translationX: 0.0, y: -800)
      self.setupOffsets()
    }) { _ in
      self.containerView.addSubview(controller.view)
    }
    UIView.animate(withDuration: 0.5, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
      self.viewControllers.insert(controller, at: 0)
      self.setupOffsets()
    }) { _ in
      self.setupGestures()
    }
  }
}
