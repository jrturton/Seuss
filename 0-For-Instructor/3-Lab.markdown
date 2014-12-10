# Advanced Debugging : Lab instructions

The bug report says that when the user types in a review, then changes the rating, the review disappears!

## Reproduction

** Make sure the hardware keyboard is not connected to the simulator: Hardware -> Keyboard -> Connect Hardware keyboard should be unchecked**

Type in a review then, while the keyboard is still present, tap one of the rating buttons. The text should disappear.
If the rating is tapped after the keyboard has been removed, the information is _not_ lost. 

## Location

Try to find the problem without changing any of the code!

Add a symbolic breakpoint on `-[UITextField setText:]` and look at the backtrace
Add a logging breakpoint to the `configureCell` closure to see what value is being set: 

```
po "\(book.title) : \(book.review)"
```

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