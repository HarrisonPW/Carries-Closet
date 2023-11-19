# Carrie's-Closet
The Carrie's Closet app is a mobile app that centralizes the numerous donation requests received by Carrie's Closet and adds functionality
through the ability to submit requests, save contact information, view donation history, and more, benefiting both users and admins.


# Release Notes

## Link to Installation Guide
https://docs.google.com/document/d/1VSTkn4_VUnNJ_xH6hnXfZDAcnEIu5uDQdCJHWNW30-s/edit?usp=sharing

## Version 1.0.0

### New Features

- Users can fill out a request form and hitting the “Submit Request” button will send the request to the database.
- Multiple items can be added to a single request.
- Users can view previously created requests.
- Users can delete previously created requests.
- Administrators can view all “processed” requests.
- Administrators can complete or deny requests.
- Administrators can view all users actively in the database.
- Administrators can make other users administrators.

### Bug Fixes

- System properly directs users/admins to their respective home pages after visiting a page that exists on both the user and admin home pages.
- The “View Orders” page for admins only displays “Processed” requests. “Completed” and “Denied” requests will no longer appear.
- The “View Users” page for admins now displays the users’ names and not their IDs from the database.
- Multi-form now validates for each field for every item.
- Multi-form works with adding multiple items in the confirmation page

### Known Bugs

- Edit profile will load in the previous user’s logged in information, and changing it will edit the previous user’s information. Occurs when you log in as one user, then logout and sign up as a new user.
- There is overflow on certain pages for some Android devices.
