# Advanced Debugging : Lab instructions

The bug report says that when the user types in a review, then changes the rating, the review disappears!

## Reproduction

** Make sure the hardware keyboard is not connected to the simulator: Hardware -> Keyboard -> Connect Hardware keyboard should be unchecked**

Type in a review then, while the keyboard is still present, tap one of the rating buttons. The text should disappear.
If the rating is tapped after the keyboard has been removed, the information is _not_ lost. 

## Location

Try to find the problem without changing any of the code!

Add a symbolic breakpoint on `-[UITextField setText:]` and look at the backtrace
Add a breakpoint to the `configureCell` closure to see what value is being set. Make the breakpoint continue after execution and add the following debugger action:

```
po "\(book.title) : \(book.review)"
```

You may want to disable the `setText` breakpoint after this point!

Add a breakpoint on `textFieldDidEndEditing` in **BooksTableViewController.swift** - this is where the review data is added to the model

You should notice that the text field's text is being set _before_ the review is added to the model

## Root cause

The button press to update the model is happening before the text field has had a chance to resign first responder and add its information to the model. The fetched results controller is then reloading the cell, and replacing the text field's contents with the stored value.

## Fix 

Add the following to `adjustRating` in **BooksTableViewController.swift**, just after the `if let` statement:

```
view.endEditing(true)
```

This will force resign any active text fields and cause their data to be added to the model before the button press is processed.

## Verify

Re-run the reproduction steps - the data will now be preserved! 

## "It crashes on the iPad"

### 1. Reproduction

The app _only_ crashes on 7.1 non-retina devices (meaning ipads). Run it in the **iPad 2 iOS 7.1 simulator**.

### 2. Location

Add a symbolic breakpoint on `-[UITableView layoutSubviews]`

Log out the autolayout trace by entering the following in the console or the debugger action on the breakpoint:

```
po [[[UIApplication sharedApplication] keyWindow] _autolayoutTrace]
```

Happens twice - fine the first time, so play on and it happens again
Look for ambiguous layout in the trace - this will be highlighted with asterisks in the view hierarchy.

### 3. Root cause

Autolayout trace suggests the activity indicator has an ambiguous layout. Perhaps there is some problem with half-pixels and scroll views. It looks like a UIKit bug which is fixed in iOS8

### 4. Fix

Change the autolayout code to use manual frames instead of autolayout. Replace all of the autolayout code with this:

```
indicator.frame.size = CGSize(width: 150, height: 150)
indicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
```

### 5. Verify

Re-test, look at the layout trace