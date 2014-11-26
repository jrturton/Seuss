# Seuss

Dr. Seuss book fan app with some subtle but deliberate bugs, as a demonstration of certain debugging techniques.

Most of the bugs are related to a special keyboard resigning overlay view which was added as a late requirement after the bulk of UAT had been completed. The requirement was to have the keyboard dismiss if the user taps anywhere else on the screen.

The tutorial is based on the stages of successful debugging (witty acronym required):

- Reproduction - unless you can reliably reproduce the bug, you'll never be sure that you've fixed it
- Location - where in the code is the bug happening? What specific line of code is doing the wrong thing?
- Root cause analysis - don't just assume that because you've found the line the bug is "on", thats where the problem originates. You need to examine the wider project and see how the app got to the buggy state in the first place. Is the real problem further upstream?
- Fix - what's the best way to fix the bug? Is it a simple typo or forgotten check, or is the app's state all wrong? Don't fix bugs by applying a set of checks and balances at the sharp end if the real problem is somewhere else.
- Confirmation - using the same reproduction steps, make sure the bug has gone, and make sure the original functionality is still working as well

## Legacy support

The activity indicator crashes the app when run in a non-retina iPad running iOS 7.1. Steps to diagnose:

- Reading the call stack
- Symbolic breakpoint on layoutSubviews
- Debugger commands to examine the _autolayoutTrace of the window and find the ambiguous layout

## WTF is happening

When entering a review, if you then tap the rate buttons the text in the review is lost. Steps to diagnose:

- Breakpoints. It's initially confusing because all of the methods you'd expect are being called properly.
- Symbolic breakpoint on textField setText, examine the call stack
 
## WTF is happening, part 2

If the keyboard is present, when you background the app and come back in, any attempt to type dismisses the keyboard. Steps to diagnose:

- Breakpoint on resign first responder

## Bonus level: Retain cycle

The keyboard dismissing view is caught in a retain cycle. Steps to diagnose:

- Use instruments to observe the number of live objects. 
- Filtering in instruments to get rid of the megaton of robot vomit that stops you seeing anything useful
- Look at the retain / release readout