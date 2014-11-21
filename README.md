# Seuss

Dr. Seuss book fan app with some subtle but deliberate bugs, as a demonstration of certain debugging techniques

## Legacy support

The activity indicator crashes the app when run in a non-retina iPad running iOS 7.1. Steps to diagnose:

- Reading the call stack
- Symbolic breakpoint on layoutSubviews