//
//  BottomSheetViewController.swift
//  bottom-sheet
//
//  Created by Bruno Lorenzo on 8/30/20.
//  Copyright © 2020 blorenzo. All rights reserved.
//

import UIKit

typealias AnimationTime = (expand: TimeInterval, collapse: TimeInterval)
typealias BothomSheetSize = (collapsed: CGFloat, expanded: CGFloat)

class BottomSheetViewController: UIViewController {

    // MARK: - Provate Properties
    
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var currentState = CardState.collapsed
    private var nextState: CardState {
        return currentState == .collapsed ? .expanded : .collapsed
    }
    private var parentFrame: CGRect {
        return self.parent?.view.frame ?? .zero
    }
    private var parentView: UIView? {
        return self.parent?.view
    }
    private var cardHeight = CGFloat.zero
    private var blurEffectView = UIVisualEffectView()
    private var nextAnimationTime: TimeInterval {
        switch nextState {
        case .expanded:
            return animationTime.expand
        case .collapsed:
            return animationTime.collapse
        }
    }
    private var bottomSheetInitialYPoint: CGFloat {
        switch nextState {
        case .expanded:
            return parentFrame.height - bottomSheetSize.expanded
        case .collapsed:
            return bottomSheetSize.collapsed
        }
    }
    
    // MARK: - Public properties
    
    public var animationTime = AnimationTime(expand: 1.5, collapse: 2.5)
    public var blurEffectType = UIBlurEffect.Style.dark
    public var bottomSheetSize = BothomSheetSize(collapsed: CGFloat.zero, expanded: CGFloat.zero)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardHeight = view.frame.height
        setupBottomSheetFrame()
        setupPanGesture()
        setupOverlapTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .red
    }
}

// MARK: - Handlers

private extension BottomSheetViewController {
    
    @objc
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateIfNeeded()
            
        case .changed:
            let translation = recognizer.translation(in: view)
            let fractionComplete: CGFloat
            
            switch currentState {
            case .collapsed:
                fractionComplete = -(translation.y / cardHeight)
            case .expanded:
                fractionComplete = translation.y / cardHeight
            }
            
            updateAnimation(with: fractionComplete)
            
        case .ended:
            continueAnimation()
            
        default:
            break
        }
    }
    
    @objc
    func handleOverlayTapGesture(_ recognizer: UITapGestureRecognizer) {
        if nextState == .collapsed {
            animateIfNeeded()
        }
    }
}

// MARK: - Setups

private extension BottomSheetViewController {
    
    func setupBottomSheetFrame() {
        let yPoint = bottomSheetSize.collapsed
        view.frame = .init(x: 0, y: yPoint, width: parentFrame.width, height: bottomSheetSize.expanded)
    }
    
    func setupPanGesture() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func setupOverlapTapGesture() {
        guard let parentView = parentView else { return }
        blurEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOverlayTapGesture)))
        parentView.addSubview(blurEffectView)
        blurEffectView.fillToSuperView(parentView)
    }
}

// MARK: - Animations Helpers

private extension BottomSheetViewController {
    
    func animateIfNeeded() {
        if runningAnimators.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: nextAnimationTime, dampingRatio: 1) {
                self.view.frame.origin.y = self.bottomSheetInitialYPoint
            }
            runningAnimators.append(frameAnimator)
            addCompletionForAnimator(frameAnimator)
            
            let cornerAnimator = UIViewPropertyAnimator(duration: nextAnimationTime, dampingRatio: 1) {
                self.view.layer.cornerRadius = self.nextState == .collapsed ? 0 : 12
            }
            runningAnimators.append(cornerAnimator)
            addCompletionForAnimator(cornerAnimator)
            
            let timingFunction = nextState == .collapsed ? UICubicTimingParameters(controlPoint1: CGPoint(x: 0.1, y: 0.75), controlPoint2: CGPoint(x: 0.25, y: 0.9)) : UICubicTimingParameters(controlPoint1: CGPoint(x: 0.75, y: 0.1), controlPoint2: CGPoint(x: 0.9, y: 0.25))
            let blurAnimator = UIViewPropertyAnimator(duration: nextAnimationTime, timingParameters: timingFunction)
            blurAnimator.addAnimations {
                self.blurEffectView.effect = self.nextState == .collapsed ? nil : UIBlurEffect(style: .dark)
            }
            runningAnimators.append(blurAnimator)
            addCompletionForAnimator(cornerAnimator)
            
            startAnimators()
        } else {
            reverseAnimators()
        }
    }
    
    func updateAnimation(with fraction: CGFloat) {
        for animator in runningAnimators {
            animator.fractionComplete += fraction
        }
    }
    
    func continueAnimation() {
        let timming = UICubicTimingParameters(animationCurve: .easeOut)
        for animator in runningAnimators {
            animator.continueAnimation(withTimingParameters: timming, durationFactor: 0)
        }
    }
    
    func addCompletionForAnimator(_ animator: UIViewPropertyAnimator) {
        animator.addCompletion { _ in
            self.currentState.toggle()
            self.runningAnimators.removeAll()
        }
    }
    
    func startAnimators() {
        runningAnimators.forEach {
            $0.startAnimation()
        }
    }
    
    func reverseAnimators() {
        runningAnimators.forEach {
            $0.isReversed = !$0.isReversed
        }
    }
}
