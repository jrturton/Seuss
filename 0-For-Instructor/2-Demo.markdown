# Advanced Debugging : Demo Instructions

**Do you have the iOS 7.1 simulator installed? If not, try to download it now as you will need it for the last bug in the lab**

## Backgrounding breaks keyboard resigner

**Use the iPhone 6 simulator, iOS 8.1**

### 1. Reproduction

The bug is seen when you call up the keyboard, background the app, come back in and try to type.

** Make sure the hardware keyboard is not connected to the simulator: Hardware -> Keyboard -> Connect Hardware keyboard should be unchecked**

### 2. Location

Add a symbolic breakpoint on `-[UITextfield resignFirstResponder]` and examine the call stack to see where the message is coming from

### 3. Root cause

The overlay view is causing resign. Why is it getting touches instead of the keyboard?
Everything appears normal in the view hierarchy inspector - looks normal
Where is this view coming from? 
Add a breakpoint on `init(frame:)` in **KeyboardDismissingOverlay.swift** and look at backtrace
Use a breakpoint in the app delegate method to change the background colour of the overlay. Set a breakpoint after the overlay view's background color has been set, and add the following debugger action:
```
expr overlay.backgroundColor = UIColor.redColor()
```

The view is behind the keyboard, and yet it is receiving touches meant for the keyboard!

### 4. Fix

Make it store the keyboard frame instead, and check the intersection before resigning responder. Add the following code at the beginning of `pointInside(point: withEvent:)` in **KeyboardDismissingOverlay.swift**:

```
// If the app goes into the background, then the foreground, the view takes touches that are meant for the keyboard
let keyboardRect = convertRect(keyboardFrame, fromView:nil)
if CGRectContainsPoint(keyboardRect, point) { 
    return false
}
```

### 5. Verify

Re-run the reproduction steps

## Retain cycle

Edit the scheme (**Product -> Scheme -> Edit Scheme...**) and make sure the *Profile* scheme uses the **Debug** build configuration.

### 1. Reproduction

Make sure "record reference counts" is selected.
Run instruments attached to the app, with the allocations tool.
Filter for *Seuss* using the top bar
Bring up and resign the keyboard a few times and watch the count of live `KeyboardDismissingOverlay` instances keep going up.

### 2. Location

Go into the allocations and look at the call stack. By the time it returns from init you'd expect the retain count to be 1, but it's 2. There's an extra retain happening in the `observeKeyboard` method

### 3. Root cause

A notification with block is being added in the `observeKeyboard` method that has a strong reference to `self`.
The observer is removed in `deinit` but that will never get called since there is a reference cycle

### 4. Fix

Use a closure capture list to change ownership of `self`. Before `notification in` in the block, add the following:
```
[unowned self]
```

### 5. Verify

Build and run the app then connect it to instruments. Observe the live instance count again.

