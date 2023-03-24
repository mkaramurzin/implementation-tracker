# Implementation Tracker

This is a Flutter web application designed to help individuals keep track of the sales process with each client but can be used for general purposes too. The app features a Firebase backend to handle authentication and database management.

## Features

- Progress tracker with clickable nodes to display step descriptions
- Drag-and-drop circular widgets to track progress
- Ability to add, edit, and delete process steps
- Dynamic updating of tracker and drag targets with a matrix system
- Firestore database integration

## Usage

To use the app, [navigate](https://implementation-tracker.web.app/) to the sign-in page and create an account or sign in with an existing account. Once logged in, you will see the main dashboard with multiple tabs, each containing a progress tracker and drag-and-drop widgets. Click on a node in the progress tracker to display the step description. Drag and drop the circular widgets to track progress and update the internal matrix. Add, edit, or delete process steps from the "edit" page found in the settings dropdown menu.

## Challenges

This was my first Flutter project that uses the Firestore database. One big challenge I encountered was that Firestore could only store a limited amount of variable types such as integers and Strings. This meant I couldn't directly store the complex objects and widgets that my app needed such as the progress tracker and tracker nodes. I overcame this challenge by converting the objects and widgets to JSON strings, which can be stored in Firestore.

Another challenge I faced was how to dynamically update the individual trackers and drag targets when a user drags and drops a widget. I ended up representing the trackers as a matrix and the first empty index of a row in the matrix would be a drag target. When a user drags a tracker widget, a function called updateMatrix handles all the logic and re-structures the internal matrix.

## Acknowledgements

Special thanks to the Firebase and Flutter communities for their excellent documentation and support.
