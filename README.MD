## Image Repository App

### Description
This app allows users to take photos using device camera or to pick a photo from the device gallery. After viewing the photo the user is able to save it to
his favorites, this will store the image to Core Data and will make the image available on the main sreen next time the App is launched. 
This App also offeres google search for images, the result for the key words returns extracted images from the links that can be viewd and saved to favorites. 
The images in favorites can be deleted when viewing a favorite image in a single view mode (click on the favorite image to open single view mode).
In favorite and google search single image view modes - swipe gestures are enabled to navigate between images with swiping right and left on the image.
All the views should be responsive on different mobile devices as well as both portrait and landscape modes. 

### Running instractions
Due to the privacy of the google API private keys I had to gitignore the info.plist file and therefore to run this application you would have to 
provide your own info.plist which will include your own Google Custome Search API_KEY and Google CX Id. Make sure the variavble names for those properties match the
names when retrieving those variables in SearchService.swift
Another additional property in my Info.plist was the requirement to ask user permision to use device camera when running this simulation on actual Iphone device 
and not a simulator.

### Appetize Demo
Appetize demo is limited because we cannot see the functionality of the Core Data. The images will get saved to favorites, but will not remain there after refresh.
Also, only gallery of the device will be accessed but not the camera.
Link: https://appetize.io/app/p175d1hzq6tgb73dk7937p1u9g?device=iphone11promax&scale=50&orientation=portrait&osVersion=14.1


### Video Demo
