<p align="center">
<img src="https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/Travel%20App.png?raw=true" height="500" />
</p>

# Travel Memory Journal

**Travel Memory Journal** is an IOS app built to **add pictures**, location and date of **visited places**.  This app is made with **UIKit**.

## ⛓ Features
- When **Travel Memory Journal** is launched for the **first time**, **introduction** screen pops out which is kind greeting method and also gives **basic information** about the app. It won't be seen after first launch.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/intro.png?raw=true" height="600" >
</p>

- After tapping on **"Get Started"** button on introduction view, user will see **main screen**. On top of the screen, there is app name. And on **top right** corner of the screen there is "**+**" (plus icon) which is for **adding post** about user's amazing travel.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/no_post.png?raw=true" height="600" >
</p>

- Let's say user tapped on "**+**" (plus icon). Then, there will be view for **picking image**. User can choose photos from library or take one. And also, user can turn on **flash**, or switch to **front camera** with button on the top.
- If user does not want to add post, he or she can tap on "Cancel" button. Or else, after selecting desired pictures, user should tap on "Done" button for moving on. Afterwards, **add view** will be pushed to the screen.
- P.S. Camera view is not available in simulator, that's is why it is blank. It will work very well on a real iPhone.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/record_1.gif?raw=true" height="600" width="300">
</p>

- Let's see what user can do on add view. Here, beginning from top of the screen, there are **images** user choosed, text field for **giving name** to trip, and cells for **adding location** from map and **date** of travel.
- In **map view**, user can automatically select his **current position** with pressing button with 📍 (pin icon). Additionally, it is possible to select one of **three different modes** (**standard, satellite** and **hybrid**) for map with pressing button with **map icon**.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/add_screen_nil.png?raw=true" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/record_2.gif?raw=true" height="600" width="300">
</p>
  
- Finally, on bottom of the screen, there is button called "**Create Post**" which will be available only when user fills up **all the fields** in the view. After pressing the button, post will be created and user will be directed to **main view**.
- User is able to **swipe horizontally** if more than one pictures added. Below picture view, there are **share** and **delete** buttons.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/add_screen_full.png?raw=true" height="600" >
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/record_3gif.gif?raw=true" height="600" width="300">
</p>

- In conclusion, **main view** shows posts with details such as **pictures, location, date** and **name** of trip and a post has buttons such as **share** and **delete**.

<p align="center">
<img src= "https://github.com/samil145/Travel_Memory_Journal/blob/main/Images/record_5.gif?raw=true" height="600" width="300" >
</p>

## Technical Background
- **Travel Memory Journal** is made with **"UIKit"** framework.
- [**ImagePicker**](https://github.com/hyperoslo/ImagePicker) by **hyperoslo** is used for image picker view and controller.
- **MVC** is applied.
