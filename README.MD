## Image Repository App

### Description
This app allows users to take photos using device camera or to pick a photo from the device gallery. After viewing the photo the user is able to save it to
his favorites, this will store the image to Core Data and will make the image available on the main sreen next time the App is launched. 
This App also offeres google search for images, the result for the key words returns extracted images from the links that can be viewd and saved to favorites. 
The images in favorites can be deleted when viewing a favorite image in a single view mode (click on the favorite image to open single view mode).
In favorite and google search single image view modes - swipe gestures are enabled to navigate between images with swiping right and left on the image.
All the views should be responsive on different mobile devices as well as both portrait and landscape modes. 

### Running instractions
Due to the privacy of the google API private keys I had to gitignore the .xcodeproj file and therefore to run this application you would have to 
create a new Xcode project and copy my files into that project as well as provide your own google private API_KEY and Custom SearchID - CX in the SearchService.swift.  
Possibly may require to do some additional setup of Core Data.

### Appetize Demo
Appetize demo is limited because we cannot see the functionality of the Core Data.
Link:
