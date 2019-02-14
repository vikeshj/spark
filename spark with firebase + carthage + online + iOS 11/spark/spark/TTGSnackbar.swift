//
//  TCCSnackBar.swift
//  spark
//
//  Created by Vikesh on 22/11/2016.
//  Copyright © 2016 Vikesh. All rights reserved.
//

import Foundation
import UIKit
import Darwin

// MARK: -
// MARK: Enum
/**
 Snackbar display duration types.
 
 - Short:   1 second
 - Middle:  3 seconds
 - Long:    5 seconds
 - Forever: Not dismiss automatically. Must be dismissed manually.
 */

@objc public enum TTGSnackbarDuration: Int {
    case short = 1
    case middle = 3
    case long = 5
    case forever = 2147483647 // Must dismiss manually.
}

/**
 Snackbar animation types.
 
 - FadeInFadeOut:               Fade in to show and fade out to dismiss.
 - SlideFromBottomToTop:        Slide from the bottom of screen to show and slide up to dismiss.
 - SlideFromBottomBackToBottom: Slide from the bottom of screen to show and slide back to bottom to dismiss.
 - SlideFromLeftToRight:        Slide from the left to show and slide to rigth to dismiss.
 - SlideFromRightToLeft:        Slide from the right to show and slide to left to dismiss.
 - Flip:                        Flip to show and dismiss.
 */

@objc public enum TTGSnackbarAnimationType: Int {
    case fadeInFadeOut
    case slideFromBottomToTop
    case slideFromBottomBackToBottom
    case slideFromLeftToRight
    case slideFromRightToLeft
    case slideFromTopToBottom
    case slideFromTopBackToTop
}

open class TTGSnackbar: UIView {
    // MARK: -
    // MARK: Class property.
    /// Snackbar default frame
    fileprivate static let snackbarDefaultFrame: CGRect = CGRect(x: 0, y: 0, width: 320, height: 44)
    
    /// Snackbar action button max width.
    fileprivate static let snackbarActionButtonMaxWidth: CGFloat = 64
    
    /// Snackbar action button min width.
    fileprivate static let snackbarActionButtonMinWidth: CGFloat = 44
    
    /// Snackbar icon imageView default width
    fileprivate static let snackbarIconImageViewWidth: CGFloat = 32
    
    // MARK: -
    // MARK: Typealias
    /// Action callback closure definition.
    public typealias TTGActionBlock = (_ snackbar:TTGSnackbar) -> Void
    
    /// Dismiss callback closure definition.
    public typealias TTGDismissBlock = (_ snackbar:TTGSnackbar) -> Void
    
    // MARK: -
    // MARK: Public property.
    /// Action callback.
    @objc open dynamic var actionBlock: TTGActionBlock? = nil
    
    /// Second action block
    @objc open dynamic var secondActionBlock: TTGActionBlock? = nil
    
    /// Dismiss callback.
    @objc open dynamic var dismissBlock: TTGDismissBlock? = nil
    
    /// Snackbar display duration. Default is Short - 1 second.
    @objc open dynamic var duration: TTGSnackbarDuration = TTGSnackbarDuration.short
    
    /// Snackbar animation type. Default is SlideFromBottomBackToBottom.
    @objc open dynamic var animationType: TTGSnackbarAnimationType = TTGSnackbarAnimationType.slideFromBottomBackToBottom
    
    /// Show and hide animation duration. Default is 0.3
    @objc open dynamic var animationDuration: TimeInterval = 0.3
    
    /// Corner radius: [0, height / 2]. Default is 4
    @objc open dynamic var cornerRadius: CGFloat = 4 {
        didSet {
            if cornerRadius > height / 2 {
                cornerRadius = height / 2
            }
            
            if cornerRadius < 0 {
                cornerRadius = 0
            }
            
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
        }
    }
    
    /// Left margin. Default is 4
    @objc open dynamic var leftMargin: CGFloat = 4 {
        didSet {
            leftMarginConstraint?.constant = leftMargin
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Right margin. Default is 4
    @objc open dynamic var rightMargin: CGFloat = 4 {
        didSet {
            rightMarginConstraint?.constant = -rightMargin
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Bottom margin. Default is 4, only work when snackbar is at bottom
    @objc open dynamic var bottomMargin: CGFloat = 4 {
        didSet {
            bottomMarginConstraint?.constant = -bottomMargin
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Top margin. Default is 4, only work when snackbar is at top
    @objc open dynamic var topMargin: CGFloat = 4 {
        didSet {
            topMarginConstraint?.constant = topMargin
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Content inset. Default is (0, 4, 0, 4)
    @objc open dynamic var contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 4, bottom: 0, right: 4) {
        didSet {
            contentViewTopConstraint?.constant = contentInset.top
            contentViewBottomConstraint?.constant = -contentInset.bottom
            contentViewLeftConstraint?.constant = contentInset.left
            contentViewRightConstraint?.constant = -contentInset.right
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
        }
    }
    
    /// Height: [44, +]. Default is 44
    @objc open dynamic var height: CGFloat = 44 {
        didSet {
            if height < 44 {
                height = 44
            }
            heightConstraint?.constant = height
            self.layoutIfNeeded()
        }
    }
    
    /// Main text shown on the snackbar.
    @objc open dynamic var message: String = "" {
        didSet {
            messageLabel.text = message
        }
    }
    
    /// Message text color. Default is white.
    @objc open dynamic var messageTextColor: UIColor = UIColor.white {
        didSet {
            messageLabel.textColor = messageTextColor
        }
    }
    
    /// Message text font. Default is Bold system font (14).
    @objc open dynamic var messageTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            messageLabel.font = messageTextFont
        }
    }
    
    /// Message text alignment. Default is left
    @objc open dynamic var messageTextAlign: NSTextAlignment = .left {
        didSet {
            messageLabel.textAlignment = messageTextAlign
        }
    }
    
    /// Action button title.
    @objc open dynamic var actionText: String = "" {
        didSet {
            actionButton.setTitle(actionText, for: UIControlState())
        }
    }
    
    /// Second action button title.
    @objc open dynamic var secondActionText: String = "" {
        didSet {
            secondActionButton.setTitle(secondActionText, for: UIControlState())
        }
    }
    
    /// Action button title color. Default is white.
    @objc open dynamic var actionTextColor: UIColor = UIColor.white {
        didSet {
            actionButton.setTitleColor(actionTextColor, for: UIControlState())
        }
    }
    
    /// Second action button title color. Default is white.
    @objc open dynamic var secondActionTextColor: UIColor = UIColor.white {
        didSet {
            secondActionButton.setTitleColor(secondActionTextColor, for: UIControlState())
        }
    }
    
    /// Action text font. Default is Bold system font (14).
    @objc open dynamic var actionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            actionButton.titleLabel?.font = actionTextFont
        }
    }
    
    /// Second action text font. Default is Bold system font (14).
    @objc open dynamic var secondActionTextFont: UIFont = UIFont.boldSystemFont(ofSize: 14) {
        didSet {
            secondActionButton.titleLabel?.font = secondActionTextFont
        }
    }
    
    /// Icon image
    @objc open dynamic var icon: UIImage? = nil {
        didSet {
            iconImageView.image = icon
        }
    }
    
    @objc open dynamic var iconTint: UIColor? = .white {
        didSet {
            iconImageView.tintColor = iconTint
        }
    }
    
    /// Icon image content
    @objc open dynamic var iconContentMode: UIViewContentMode = .center {
        didSet {
            iconImageView.contentMode = iconContentMode
        }
    }
    
    /// Custom container view
    @objc open dynamic var containerView: UIView?
    
    /// Custom content view
    @objc open dynamic var customContentView: UIView?
    
    /// SeparateView background color
    @objc open dynamic var separateViewBackgroundColor: UIColor = UIColor.gray {
        didSet {
            separateView.backgroundColor = separateViewBackgroundColor
        }
    }
    
    // MARK: -
    // MARK: Private property.
    fileprivate var contentView: UIView!
    fileprivate var iconImageView: UIImageView!
    fileprivate var messageLabel: UILabel!
    fileprivate var separateView: UIView!
    fileprivate var actionButton: UIButton!
    fileprivate var secondActionButton: UIButton!
    fileprivate var activityIndicatorView: UIActivityIndicatorView!
    
    /// Timer to dismiss the snackbar.
    fileprivate var dismissTimer: Timer? = nil
    
    // Constraints.
    fileprivate var heightConstraint: NSLayoutConstraint? = nil
    fileprivate var leftMarginConstraint: NSLayoutConstraint? = nil
    fileprivate var rightMarginConstraint: NSLayoutConstraint? = nil
    fileprivate var bottomMarginConstraint: NSLayoutConstraint? = nil
    fileprivate var topMarginConstraint: NSLayoutConstraint? = nil // Only work when top animation type
    
    fileprivate var centerXConstraint: NSLayoutConstraint? = nil // Only work when customContentView is set
    fileprivate var widthConstraint: NSLayoutConstraint? = nil // Only work when customContentView is set
    
    // Content constraints.
    fileprivate var iconImageViewWidthConstraint: NSLayoutConstraint? = nil
    fileprivate var actionButtonWidthConstraint: NSLayoutConstraint? = nil
    fileprivate var secondActionButtonWidthConstraint: NSLayoutConstraint? = nil
    
    fileprivate var contentViewLeftConstraint: NSLayoutConstraint? = nil
    fileprivate var contentViewRightConstraint: NSLayoutConstraint? = nil
    fileprivate var contentViewTopConstraint: NSLayoutConstraint? = nil
    fileprivate var contentViewBottomConstraint: NSLayoutConstraint? = nil
    
    // MARK: -
    // MARK: Default init
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: TTGSnackbar.snackbarDefaultFrame)
        configure()
    }
    
    /**
     Default init
     
     - returns: TTGSnackbar instance
     */
    public init() {
        super.init(frame: TTGSnackbar.snackbarDefaultFrame)
        configure()
    }
    
    /**
     Show a single message like a Toast.
     
     - parameter message:  Message text.
     - parameter duration: Duration type.
     
     - returns: TTGSnackbar instance
     */
    public init(message: String, duration: TTGSnackbarDuration) {
        super.init(frame: TTGSnackbar.snackbarDefaultFrame)
        self.duration = duration
        self.message = message
        configure()
    }
    
    /**
     Show a message with action button.
     
     - parameter message:     Message text.
     - parameter duration:    Duration type.
     - parameter actionText:  Action button title.
     - parameter actionBlock: Action callback closure.
     
     - returns: TTGSnackbar instance
     */
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, actionBlock: @escaping TTGActionBlock) {
        super.init(frame: TTGSnackbar.snackbarDefaultFrame)
        self.duration = duration
        self.message = message
        self.actionText = actionText
        self.actionBlock = actionBlock
        configure()
    }
    
    /**
     Show a custom message with action button.
     
     - parameter message:          Message text.
     - parameter duration:         Duration type.
     - parameter actionText:       Action button title.
     - parameter messageFont:      Message label font.
     - parameter actionButtonFont: Action button font.
     - parameter actionBlock:      Action callback closure.
     
     - returns: TTGSnackbar instance
     */
    public init(message: String, duration: TTGSnackbarDuration, actionText: String, messageFont: UIFont, actionTextFont: UIFont, actionBlock: @escaping TTGActionBlock) {
        super.init(frame: TTGSnackbar.snackbarDefaultFrame)
        self.duration = duration
        self.message = message
        self.actionText = actionText
        self.actionBlock = actionBlock
        self.messageTextFont = messageFont
        self.actionTextFont = actionTextFont
        configure()
    }
}

// MARK: -
// MARK: Show methods.
public extension TTGSnackbar {
    
    /**
     Show the snackbar.
     */
    public func show() {
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Create dismiss timer
        dismissTimer = Timer.scheduledTimer(timeInterval: (TimeInterval)(duration.rawValue), target: self, selector: #selector(dismiss), userInfo: nil, repeats: false)
        
        // Show or hide action button
        iconImageView.isHidden = icon == nil
        actionButton.isHidden = actionText.isEmpty || actionBlock == nil
        secondActionButton.isHidden = secondActionText.isEmpty || secondActionBlock == nil
        separateView.isHidden = actionButton.isHidden
        iconImageViewWidthConstraint?.constant = iconImageView.isHidden ? 0 : TTGSnackbar.snackbarIconImageViewWidth
        actionButtonWidthConstraint?.constant = actionButton.isHidden ? 0 : (secondActionButton.isHidden ? TTGSnackbar.snackbarActionButtonMaxWidth : TTGSnackbar.snackbarActionButtonMinWidth)
        secondActionButtonWidthConstraint?.constant = secondActionButton.isHidden ? 0 : (actionButton.isHidden ? TTGSnackbar.snackbarActionButtonMaxWidth : TTGSnackbar.snackbarActionButtonMinWidth)
        
        // Content View
        let finalContentView = customContentView ?? contentView
        finalContentView?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(finalContentView!)
        
        contentViewTopConstraint = NSLayoutConstraint.init(item: finalContentView!, attribute: .top, relatedBy: .equal,
                                                           toItem: self, attribute: .top, multiplier: 1, constant: contentInset.top)
        contentViewBottomConstraint = NSLayoutConstraint.init(item: finalContentView!, attribute: .bottom, relatedBy: .equal,
                                                              toItem: self, attribute: .bottom, multiplier: 1, constant: -contentInset.bottom)
        contentViewLeftConstraint = NSLayoutConstraint.init(item: finalContentView!, attribute: .left, relatedBy: .equal,
                                                            toItem: self, attribute: .left, multiplier: 1, constant: contentInset.left)
        contentViewRightConstraint = NSLayoutConstraint.init(item: finalContentView!, attribute: .right, relatedBy: .equal,
                                                             toItem: self, attribute: .right, multiplier: 1, constant: -contentInset.right)
        
        self.addConstraints([contentViewTopConstraint!, contentViewBottomConstraint!, contentViewLeftConstraint!, contentViewRightConstraint!])
        
        // Get super view to show
        if let superView = containerView ?? UIApplication.shared.keyWindow {
            superView.addSubview(self)
            
            // Snackbar height constraint
            var trueHeight: CGFloat = height
            if let trueContentView = customContentView {
                trueHeight = trueContentView.bounds.size.height + contentInset.top + contentInset.bottom
            }
            
            heightConstraint = NSLayoutConstraint.init(item: self, attribute: .height,
                                                       relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: trueHeight)
            
            // Snackbar width constraint
            var trueWidth: CGFloat = UIScreen.main.bounds.size.width - leftMargin - rightMargin
            if let trueContentView = customContentView {
                trueWidth = trueContentView.bounds.size.width + contentInset.left + contentInset.right
            }
            
            widthConstraint = NSLayoutConstraint.init(item: self, attribute: .width,
                                                      relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: trueWidth)
            
            // Left margin constraint
            leftMarginConstraint = NSLayoutConstraint.init(item: self, attribute: .left,
                                                           relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1, constant: leftMargin)
            
            // Right margin constraint
            rightMarginConstraint = NSLayoutConstraint.init(item: self, attribute: .right,
                                                            relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1, constant: -rightMargin)
            
            // Bottom margin constraint
            bottomMarginConstraint = NSLayoutConstraint.init(item: self, attribute: .bottom,
                                                             relatedBy: .equal, toItem: superView, attribute: .bottom, multiplier: 1, constant: -bottomMargin)
            
            // Top margin constraint
            topMarginConstraint = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1, constant: topMargin)
            
            // Center X constraint
            centerXConstraint = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1, constant: 0)
            
            // Avoid the "UIView-Encapsulated-Layout-Height" constraint conflicts
            // http://stackoverflow.com/questions/25059443/what-is-nslayoutconstraint-uiview-encapsulated-layout-height-and-how-should-i
            leftMarginConstraint?.priority = UILayoutPriority(rawValue: 999)
            rightMarginConstraint?.priority = UILayoutPriority(rawValue: 999)
            topMarginConstraint?.priority = UILayoutPriority(rawValue: 999)
            bottomMarginConstraint?.priority = UILayoutPriority(rawValue: 999)
            centerXConstraint?.priority = UILayoutPriority(rawValue: 999)
            
            // Add constraints
            self.addConstraint(heightConstraint!)
            self.addConstraint(widthConstraint!)
            superView.addConstraint(leftMarginConstraint!)
            superView.addConstraint(rightMarginConstraint!)
            superView.addConstraint(bottomMarginConstraint!)
            superView.addConstraint(topMarginConstraint!)
            superView.addConstraint(centerXConstraint!)
            
            topMarginConstraint?.isActive = false
            
            leftMarginConstraint?.isActive = customContentView == nil
            rightMarginConstraint?.isActive = customContentView == nil
            centerXConstraint?.isActive = customContentView != nil
            widthConstraint?.isActive = customContentView != nil
            
            // Show
            showWithAnimation()
        } else {
            fatalError("TTGSnackbar needs a keyWindows to display.")
        }
    }
    
    /**
     Show.
     */
    fileprivate func showWithAnimation() {
        var animationBlock: (() -> Void)? = nil
        let superViewWidth = (superview?.frame)!.width
        
        switch animationType {
        case .fadeInFadeOut:
            self.alpha = 0.0
            // Animation
            animationBlock = {
                self.alpha = 1.0
            }
        case .slideFromBottomBackToBottom, .slideFromBottomToTop:
            bottomMarginConstraint?.constant = (heightConstraint?.constant)!
        case .slideFromLeftToRight:
            leftMarginConstraint?.constant = leftMargin - superViewWidth
            rightMarginConstraint?.constant = -rightMargin - superViewWidth
            bottomMarginConstraint?.constant = -bottomMargin
            centerXConstraint?.constant = -superViewWidth
        case .slideFromRightToLeft:
            leftMarginConstraint?.constant = leftMargin + superViewWidth
            rightMarginConstraint?.constant = -rightMargin + superViewWidth
            bottomMarginConstraint?.constant = -bottomMargin
            centerXConstraint?.constant = superViewWidth
        case .slideFromTopBackToTop, .slideFromTopToBottom:
            bottomMarginConstraint?.isActive = false
            topMarginConstraint?.isActive = true
            topMarginConstraint?.constant = -(heightConstraint?.constant)!
        }
        
        // Update init state
        self.superview?.layoutIfNeeded()
        
        // Final state
        bottomMarginConstraint?.constant = -bottomMargin
        topMarginConstraint?.constant = topMargin
        leftMarginConstraint?.constant = leftMargin
        rightMarginConstraint?.constant = -rightMargin
        centerXConstraint?.constant = 0
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .allowUserInteraction,
                       animations: {
                        () -> Void in
                        animationBlock?()
                        self.superview?.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: -
// MARK: Dismiss methods.
public extension TTGSnackbar {
    /**
     Dismiss the snackbar manually.
     */
    @objc public func dismiss() {
        // On main thread
        DispatchQueue.main.async {
            () -> Void in
            self.dismissAnimated(true)
        }
    }
    
    /**
     Dismiss.
     
     - parameter animated: If dismiss with animation.
     */
    fileprivate func dismissAnimated(_ animated: Bool) {
        // If the dismiss timer is nil, snackbar is dismissing or not ready to dismiss.
        if dismissTimer == nil {
            return
        }
        
        invalidDismissTimer()
        activityIndicatorView.stopAnimating()
        
        let superViewWidth = (superview?.frame)!.width
        
        if !animated {
            dismissBlock?(self)
            self.removeFromSuperview()
            return
        }
        
        var animationBlock: (() -> Void)? = nil
        
        switch animationType {
        case .fadeInFadeOut:
            animationBlock = {
                self.alpha = 0.0
            }
        case .slideFromBottomBackToBottom:
            bottomMarginConstraint?.constant = (heightConstraint?.constant)!
        case .slideFromBottomToTop:
            animationBlock = {
                self.alpha = 0.0
            }
            bottomMarginConstraint?.constant = -(heightConstraint?.constant)! - bottomMargin
        case .slideFromLeftToRight:
            leftMarginConstraint?.constant = leftMargin + superViewWidth
            rightMarginConstraint?.constant = -rightMargin + superViewWidth
            centerXConstraint?.constant = superViewWidth
        case .slideFromRightToLeft:
            leftMarginConstraint?.constant = leftMargin - superViewWidth
            rightMarginConstraint?.constant = -rightMargin - superViewWidth
            centerXConstraint?.constant = -superViewWidth
        case .slideFromTopToBottom:
            topMarginConstraint?.isActive = false
            bottomMarginConstraint?.isActive = true
            bottomMarginConstraint?.constant = (heightConstraint?.constant)!
        case .slideFromTopBackToTop:
            topMarginConstraint?.constant = -(heightConstraint?.constant)!
        }
        
        self.setNeedsLayout()
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.2, options: .curveEaseIn,
                       animations: {
                        () -> Void in
                        animationBlock?()
                        self.superview?.layoutIfNeeded()
        }) {
            (finished) -> Void in
            self.dismissBlock?(self)
            self.removeFromSuperview()
        }
    }
    
    /**
     Invalid the dismiss timer.
     */
    fileprivate func invalidDismissTimer() {
        dismissTimer?.invalidate()
        dismissTimer = nil
    }
}

// MARK: -
// MARK: Init configuration.
private extension TTGSnackbar {
    func configure() {
        // Clear subViews
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame = CGRect.init(x: 0, y: 0, width: 320, height: height) // Init frame
        contentView.backgroundColor = UIColor.clear
        
        iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.backgroundColor = UIColor.clear
        iconImageView.contentMode = iconContentMode
        contentView.addSubview(iconImageView)
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = UIColor.white
        messageLabel.font = messageTextFont
        messageLabel.backgroundColor = UIColor.clear
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .left
        messageLabel.text = message
        contentView.addSubview(messageLabel)
        
        actionButton = UIButton()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = UIColor.clear
        actionButton.titleLabel?.font = actionTextFont
        actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        actionButton.setTitle(actionText, for: UIControlState())
        actionButton.setTitleColor(actionTextColor, for: UIControlState())
        actionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
        contentView.addSubview(actionButton)
        
        secondActionButton = UIButton()
        secondActionButton.translatesAutoresizingMaskIntoConstraints = false
        secondActionButton.backgroundColor = UIColor.clear
        secondActionButton.titleLabel?.font = secondActionTextFont
        secondActionButton.titleLabel?.adjustsFontSizeToFitWidth = true
        secondActionButton.setTitle(secondActionText, for: UIControlState())
        secondActionButton.setTitleColor(secondActionTextColor, for: UIControlState())
        secondActionButton.addTarget(self, action: #selector(doAction(_:)), for: .touchUpInside)
        contentView.addSubview(secondActionButton)
        
        separateView = UIView()
        separateView.translatesAutoresizingMaskIntoConstraints = false
        separateView.backgroundColor = separateViewBackgroundColor
        contentView.addSubview(separateView)
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.stopAnimating()
        contentView.addSubview(activityIndicatorView)
        
        // Add constraints
        let hConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[iconImageView]-2-[messageLabel]-2-[seperateView(0.5)]-2-[actionButton]-0-[secondActionButton]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["iconImageView": iconImageView, "messageLabel": messageLabel, "seperateView": separateView, "actionButton": actionButton, "secondActionButton": secondActionButton])
        
        let vConstraintsForIconImageView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-2-[iconImageView]-2-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["iconImageView": iconImageView])
        
        let vConstraintsForMessageLabel: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[messageLabel]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["messageLabel": messageLabel])
        
        let vConstraintsForSeperateView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-4-[seperateView]-4-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["seperateView": separateView])
        
        let vConstraintsForActionButton: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[actionButton]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["actionButton": actionButton])
        
        let vConstraintsForSecondActionButton: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[secondActionButton]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["secondActionButton": secondActionButton])
        
        iconImageViewWidthConstraint = NSLayoutConstraint.init(
            item: iconImageView, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarIconImageViewWidth)
        
        actionButtonWidthConstraint = NSLayoutConstraint.init(
            item: actionButton, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarActionButtonMinWidth)
        
        secondActionButtonWidthConstraint = NSLayoutConstraint.init(
            item: secondActionButton, attribute: .width, relatedBy: .equal,
            toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: TTGSnackbar.snackbarActionButtonMinWidth)
        
        let vConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-2-[activityIndicatorView]-2-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: ["activityIndicatorView": activityIndicatorView])
        
        let hConstraintsForActivityIndicatorView: [NSLayoutConstraint] = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[activityIndicatorView(activityIndicatorWidth)]-2-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: ["activityIndicatorWidth": height - 4],
            views: ["activityIndicatorView": activityIndicatorView])
        
        iconImageView.addConstraint(iconImageViewWidthConstraint!)
        actionButton.addConstraint(actionButtonWidthConstraint!)
        secondActionButton.addConstraint(secondActionButtonWidthConstraint!)
        
        contentView.addConstraints(hConstraints)
        contentView.addConstraints(vConstraintsForIconImageView)
        contentView.addConstraints(vConstraintsForMessageLabel)
        contentView.addConstraints(vConstraintsForSeperateView)
        contentView.addConstraints(vConstraintsForActionButton)
        contentView.addConstraints(vConstraintsForSecondActionButton)
        contentView.addConstraints(vConstraintsForActivityIndicatorView)
        contentView.addConstraints(hConstraintsForActivityIndicatorView)
    }
}

// MARK: -
// MARK: Actions
private extension TTGSnackbar {
    /**
     Action button callback
     
     - parameter button: action button
     */
    @objc func doAction(_ button: UIButton) {
        // Call action block first
        button == actionButton ? actionBlock?(self) : secondActionBlock?(self)
        
        // Show activity indicator
        if duration == .forever && actionButton.isHidden == false {
            actionButton.isHidden = true
            secondActionButton.isHidden = true
            separateView.isHidden = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            dismissAnimated(true)
        }
    }
}
