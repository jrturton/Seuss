# Advanced Debugging : Challenge instructions

## Where are my borders?

When viewing the details of a book, there are supposed to be three nested bordered views, holding the title, rating and cover of the book. 

Cleaning and building the project sometimes fixes the issue, sometimes makes it worse.

### 1. Reproduction

Open the detail view. You should see red, orange and blue containers. If you don't you've reproduced the bug!

### 2. Location

The border styles are set via the `IBInspectable` property `topBorder` in the storyboard. Find out how this property works and where it is implemented.

### 3. Root cause

Use logging breakpoints to work out what is going wrong. Why does setting the property not always result in a border around the relevant view?

**HINT**: _Tags are horrible and should never be used. You may wish to look at the documentation for_ `viewWithTag`

### 4. Fix

What is a better way that this could be implemented? 

**HINT**: _How can you add properties to an object in an extension or category?_

### 5. Verify

Open the detail view and revel in the glory of your three nested, bordered views!

