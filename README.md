# Carrie's-Closet
The Carrie's Closet app is a mobile app that centralizes the numerous donation requests received by Carrie's Closet and adds functionality
through the ability to submit requests, save contact information, view donation history, and more, benefiting both users and admins.


# Release Notes

## Link to Installation Guide
[https://docs.google.com/document/d/1VSTkn4_VUnNJ_xH6hnXfZDAcnEIu5uDQdCJHWNW30-s/edit?usp=sharing](https://docs.google.com/document/d/1ZN2thN32yARNK8v4UWeExhZfq5TYpkLs7vTdl3PxPgc/edit?usp=sharing)

## Version 1.4.0

### Suggestion For Possible Alternative
The increasing popularity of apps on cloud have now made it feasible and even more efficient to simply host servers on the browser. While mobile applications are more secure and seemingly more convinient, for the usecase of Carrie's Closet, we believe that migrating to a website based approach better fits their needs, avoids the hassle of getting the apple store and google store to approve the app, avoids integration and release issues with keeping the tech stack up to date and well regulated across multiple types of mobile devices, is easier to implement and upkeep, is more functional, and avoids installation difficulties. Summarized and expanded below, here would be the benefits of switching to a web based solution:

- Broader Accessibility: Web-based solutions are accessible on a wider range of devices, not limited to smartphones.
- No Installation Required: Users can access web applications directly in their browser without needing to download anything.
- Easier Maintenance and Updates: Updates to web-based applications are immediate and universal, without user intervention.
- Cross-Platform Compatibility: Web apps reduce the need for multiple versions across different mobile platforms, simplifying development.
- Improved SEO and Online Visibility: Web-based solutions are more easily discoverable through search engines due to SEO.
- No App Store Dependencies: Web apps bypass app store restrictions, approvals, and revenue sharing models.
- Easier Integration with Other Web Services: Web applications can more seamlessly integrate with online services and APIs.
- Potential Cost Savings: Development and maintenance costs for web-based solutions can be lower than for mobile apps.
- Instant Accessibility to Updates: Any updates to a web-based application are immediately available to all users.
- Scalability: Web applications can be scaled more easily to accommodate user growth or increased data loads.

Specifically given the use case of Carrie's Closet, where features that mobile applications excel in such as better performance, offline access, and access to device-specific features (like camera, GPS, etc, are not necessary, we strongly reccomend considering a migration to a web based solution. Not only would a web based solution help with the above, but it would be comprehensive of the current functionalities of the app, and could display the functionalites uniquely to each device (mobile or computer) that could access it from any browser.

In retrospect, after working with the current tech stack and understanding the current functionalities, it seems that the added complexities of creating a mobile app over a web-based solution is not completely justified unless if added functionalities for future implementation and planning require the mobile interface and features unique to it.

Furthermore, the tech stack required to develop a web based solution are much more common in the industry and are better known by working professionals and students than the current tech stack (ie flutter). Therefore, if such a solution is adopted, it will make it significantly easier for the onboarding process from team to team, and will have a much less steeper learning curve. Switching gears may provide a better oppurtunity to work on something better understood and thus better implemented, especially considering the plethora of available documentation on such implementations.

If this option is considered, future teams working on this project should be able to migrate several parts of code from this project to the web based solution, including the business logic and backend api calls.

### Future Requirements
- The actual app must be integrated with this page. The backend API calls are properly written and set up, as well as the front end for this page, however, the app does not yet integrate this page.
- Integrating the actual page should be an easy task. The difficulty our team was facing was due to the inability to properly log in and connect from the application side. Please reach out to the first team who implemented the app to resolve this issue.
- Consider migration of app to web based solution, see more in write up above.

### New Features

- Administrators can view an inventory page that clearly displays the inventory of clothes.
- Administrators can make changes such as removing items, updating them, or adding new items on the inventory page.
- There are now more options for sizing, including the full clothing range from XXS to XXL instead of just small, medium, and large.

### Bug Fixes

- N/A

### Known Bugs

- Edit profile will load in the previous user’s logged in information, and changing it will edit the previous user’s information. Occurs when you log in as one user, then logout and sign up as a new user.
- There is overflow on certain pages for some Android devices.

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
