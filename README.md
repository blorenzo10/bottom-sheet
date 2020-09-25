###  Custom Bottom Sheet
Reusable Bottom Sheet View Controller using property animator.

You can configure the duration of the expand/contract animation and the bottom sheet height. All by code =)

##### Usage
1. Download the files under BottomSheet/ folder and copy into your project
2. You need to inherit the view controller that you want as bottom sheet from BottomSheetViewController
3. Make the initial setup

```swift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSize = view.frame.size
        let bottomSheetViewController = CardViewController() // CardViewController inherit from BotttomSheetViewController
        bottomSheetViewController.animationTime = AnimationTime(expand: 0.7, collapse: 1.5)
        bottomSheetViewController.bottomSheetSize = BothomSheetSize(collapsed: viewSize.height - 80, expanded: viewSize.height - 200)
        
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetViewController.view)
    }
}
```
