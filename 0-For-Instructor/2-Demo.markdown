# Advanced Debugging : Demo Instructions

A lot of the bugs we're going to look at are related to a single feature, which the client decided late in the process that they wanted to have. This is not a coincidence!

## "It crashes on the iPad"

### Reproduction

The app _only_ crashes on 7.1 non-retina devices (meaning ipads). Run it in the **iPad 2 iOS 7.1 simulator**.

### Location

Add a symbolic breakpoint on `-[UITableView layoutSubviews]`

Log out the autolayout trace by entering the following in the console or the debugger action on the breakpoint:

```
po [[[UIApplication sharedApplication] keyWindow] _autolayoutTrace]
```

Happens twice - fine the first time, so play on and it happens again
Look for ambiguous layout

### Root cause

Autolayout trace suggests the activity indicator has an ambiguous layout. Perhaps there is some problem with half-pixels and scroll views. It looks like a UIKit bug which is fixed in iOS8

### Fix

Change the autolayout code to manual frames:

```
indicator.frame.size = CGSize(width: 150, height: 150)
indicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
```

### Verify

Re-test, look at the layout trace

## Backgrounding breaks keyboard resigner

**Switch back to iphone 6 simulator, iOS 8.1**

### Reproduction

The bug is seen when you call up the keyboard, background the app, come back in and try to type.

### Location

Add a symbolic breakpoint on `-[UITextfield resignFirstResponder]`

### Root cause

The overlay view is causing resign. Why is it getting touches instead of the keyboard?
Everything appears normal in the view hierarchy inspector - looks normal
Where is this view coming from? 
Add a breakpoint on `init(frame:)` in **KeyboardDismissingOverlay.swift** and look at backtrace
Use a breakpoint in the app delegate method to change the background colour of the overlay. Set a breakpoint after the overlay view's background color has been set, and add the following debugger action:
```
expr overlay.backgroundColor = UIColor.redColor()
```

The view is behind the keyboard, and yet it is receiving touches meant for the keyboard!

### Fix

Make it store the keyboard frame instead, and check the intersection before resigning responder. Add the following code at the beginning of `pointInside(point: withEvent:)` in **KeyboardDismissingOverlay.swift**:

```
// If the app goes into the background, then the foreground, the view takes touches that are meant for the keyboard
let keyboardRect = convertRect(keyboardFrame, fromView:nil)
if CGRectContainsPoint(keyboardRect, point) { 
    return false
}
```

### Verify

Re-run the reproduction steps

## Retain cycle

Edit the scheme (**Product -> Scheme -> Edit Scheme...**) and make sure the *Profile* scheme uses the **Debug** build configuration.

### Reproduction

Run instruments attached to the app, with the allocations tool.
Make sure "record reference counts" is selected
Filter for *Seuss* using the top bar
Bring up and resign the keyboard a few times and watch the count of live `KeyboardDismissingOverlay` instances keep going up.

### Location

Go into the allocations and look at the call stack. By the time it returns from init you'd expect the retain count to be 1, but it's 2. There's extra in the observeKeyboard method

### Root cause

A notification with block is being added in the `observeKeyboard` method that has a strong reference to `self`.
The observer is removed in `deinit` but that will never get called since there is a reference cycle

### Fix

Use a closure capture list to change ownership of `self`. Before `notification in` in the block, add the following:
```
[unowned self]
```

### Verify

Build and run the app then connect it to instruments. Observe the live instance count again.
