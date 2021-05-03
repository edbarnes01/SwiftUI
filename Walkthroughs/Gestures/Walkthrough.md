<!-- CUSTOM TABS -->
## Gestures

Hi all! In this walkthrough I’ll be talking about gestures and how you can use them to create cool effects. This project focuses on the ```DragGesture()``` (but also includes ```.onTapGesture{}```). I decided a cool way to show you how this could work would be to recreate a home screen. This produced some interesting results... I rather like using SF Symbols instead of the normal icons for these apps 👀. Anyway, without further delay, let's jump in!

Disclaimer: Forgive me St.George for using "color" instead of the obviously correct, "colour" 😔
* [Preview](#preview)
* [Setup](#setup)
* [Creating The Pages](#creating-the-pages)
* [Gesture](#gesture)
* [Cba with your incredibly useful explanations](#swipe-gesture)

## Preview
<img src="https://user-images.githubusercontent.com/68400711/116878953-f0da5d80-ac17-11eb-91d2-509c43505981.gif" width="250" height="500"/>

## Setup

If you know how I like to set up my projects then you'll be familiar with these file names. If not, maybe check [this](https://github.com/edbarnes01/SwiftUI/tree/main/BeforeYouRead#file-structure) out.

These are the files you're going to need and which option you should choose:

- Container (SwiftUI)
- Main      (SwiftUI)
- HomePage  (SwiftUI)
- Models    (Swift)
- Service   (Swift)
- Themes    (Swift)

First thing we need to do is go into models and create some structs. I'll create one for each icon that will be on pages:

``` swift
struct Icon: Hashable {
    var name: String
    var icon: String
    var foreground: Color
    var background: Color
}
```
(```icon``` will be the SF Symbol name)

And then one to contain all that data:

``` swift
struct PageData: Hashable {
    var pageNo: Int
    var icons: [Icon]
}
```

These both need to be hashable in order to use them in a ForEach.

Next we need to create all the icons. Feel free to just copy and paste the same ones I created, which you'll find in my ```Models.swift``` file. If you want to create your own, go wild! The way I did it was create 3 page variables like this: 

``` swift
let examplePageZero =
let examplePageOne =
let examplePageSecond =
```

And then define those variables as type ```PageData()```, passing in all the required variables. Then I made an array of these variables:

``` swift
let examplePages = [examplePageZero, examplePageOne, examplePageTwo]
```
I also made a variable in this file called ```exampleBottomBar``` which includes 4 icons that I will use for, you guessed it, the bottom bar.

We'll use these to set up our service now!

### Service Setup

Let's create our service! Check [here](https://github.com/edbarnes01/SwiftUI/tree/main/BeforeYouRead#service) if you haven't got a clue what I mean when I say service.

First import SwiftUI at the top (so we can access CGFloat) and then let's define these variables:

``` swift 
import Foundation
import SwiftUI

class Service: ObservableObject {
    @Published var pages = examplePages
    @Published var bottomBar = exampleBottomBar
    @Published private(set) var activePage: Int = 0
    @Published var iconSize: CGFloat = UIScreen.main.bounds.width / 6
}
```

So we have our page data, our icons for the bottom bar, our current page number and the size that our icons will be. You can play around with this number obviously but I found that the screen width divided by 6 a good number to use. Also, I should say that ```private(set)``` tells XCode that this variable can only be changed within the scope of service. If we tried to change the variable manually from somewhere else in our app, we wouldn't be able to! This is very helpful for debugging but also means we need a function within our service to change it!

And on that note... we'll need just two functions within the service, the first to check if a page number is the active page number and the second to change the page:

``` swift
class Service: ObservableObject {
    @Published var pages = examplePages
    @Published var bottomBar = exampleBottomBar
    @Published private(set) var activePage: Int = 0
    @Published var iconSize: CGFloat = UIScreen.main.bounds.width / 6
    
    func isActivePage(pageNo: Int) -> Bool {
        return activePage == pageNo
    }
    
    func changePage(_ pageNumber: Int) {
        self.activePage = pageNumber
    }
}
```

These are quite self explanatory I think!

## Creating the pages

A typical home screen has 3 main elements, the icons, the little circles (page scroll) and the bottom bar with 4/5 more icons. 

### Icons

<img src="https://user-images.githubusercontent.com/68400711/116886894-8d552d80-ac21-11eb-94e9-8584efbb6827.png" width="250" height="450"/>

Let’s start with the icon section which I have named ```HomePage```. Open up ```HomePage.swift``` and within the ```HomePage``` struct let’s define our service environment object and then also define our page number variable:

``` swift
struct HomePage: View {
    @EnvironmentObject var service: Service
    var pageNo: Int

    ...
````
Great! Now, the icons.
I found the best way to recreate the icons was to use a ```LazyVGrid()```. We'll put that inside a Vstack:
``` swift
struct HomePage: View {
    @EnvironmentObject var service: Service
    var pageNo: Int
    
    var body: some View {
        VStack {
            LazyVGrid(columns:[ GridItem(.adaptive(minimum: self.service.iconSize))],
                      alignment: .center,
                      spacing: 20) {
                      // Content
            }.padding(20)
            Spacer()
        }.background(Color.black.opacity(0.01))
    }
}
```

So with a LazyVGrid, we need to define the layout for the cells in our grid. For a VGrid, the cells will be organised in Columns and for an HGrid, rows. Within the ```columns:``` parameter, you can tell SwiftUI your layout preferences. For this project, I went with adaptive cells (```.adaptive()```) but you could also used fixed sizes as well. However, i did want to specify that the cells should always be at least as big as our icon size we defined in our service. Also, make sure to add a background that is almost invisible - this is a work around so that our gesture will work no matter where we drag on our page.

For the content (where ```// Content``` is) I'll create a separate struct called ```IconView``` and make it conform to View. Add a body with some text in to keep XCode happy and then let's also define some variables at the top:

``` swift
struct IconView: View {
    @EnvironmentObject var service: Service
    var icon: Icon
    var showText: Bool
    
    var body: some View {
        Text("Keeping XCode happy!")
    }
}
```

So we've got our service, the data for the icon and wether we want to display the name of the icon underneath it - this is used for the bottom bar icons, where we don't want text.

Let's make a pretty Icon!

``` swift 
struct IconView: View {
    @EnvironmentObject var service: Service
    var icon: Icon
    var showText: Bool
    var body: some View {
        VStack{
            VStack{
                Image(systemName: icon.icon)
                    .foregroundColor(icon.foreground)
                    .font(.system(size: self.service.iconSize / 5 * 3))
            }
            .frame(width: self.service.iconSize, height: self.service.iconSize)
            .background(icon.background)
            .clipShape(RoundedRectangle(cornerRadius: self.service.iconSize / 5))
            if showText {
                Text(icon.name)
                    .foregroundColor(.white)
                    .font(.system(size: 12))
                    .offset(x: 0, y: 2)
            }
        }
    }
}
```

Great! We've got our icon image and defined the foreground color and size (I found 5/3 of the icon size to be a nice size) all within a VStack. That VStack's height and width will be the icon size from our service, the background is the color we defined in the icon data and then we clip it so that its a nice rounded rectangle - again, the corner radius is just what I found looks best, feel free to experiment! And then our icon name if our showText variable is true!

Cool, now let's go back to our ```HomePage``` LazyVGrid and fil in the content!

``` swift 
struct HomePage: View {
    @EnvironmentObject var service: Service
    var pageNo: Int
    
    var body: some View {
        VStack {
            LazyVGrid(columns:[ GridItem(.adaptive(minimum: self.service.iconSize))],
                      alignment: .center,
                      spacing: 20) {
                ForEach(self.service.pages[pageNo].icons, id: \.self) { icon in
                    IconView(icon: icon, showText: true).environmentObject(service)
                }
            }.padding(20)
            Spacer()
        }.background(Color.black.opacity(0.01))
    }
}
```

This is just a ForEach using the ```PageData``` item's icons that corresponds with our page number and with our new ```IconView``` as it's content. Awesome!

Note: The colors I'm using here work for a dark background. I'll cover Color schemes and light/dark mode in a different walkthrough!

### Page Scroll Circles

 <img width="366" alt="Screenshot 2021-05-03 at 15 11 34" src="https://user-images.githubusercontent.com/68400711/116887136-dad19a80-ac21-11eb-8783-99e7106725ab.png">

Jump back into ```Main.swift```. Let's create a new Struct called ```PageScroll``` and make it conform to View. This view will only require our service. So this is how I created it:

``` swift
struct PageScroll: View {
    @EnvironmentObject var service: Service
    var body: some View {
        HStack{
            HStack {
                ForEach(self.service.pages, id:\.self) { page in
                    Image(systemName: "circlebadge.fill")
                        .foregroundColor(self.service.isActivePage(pageNo: page.pageNo) ? .white : .gray)
                        .onTapGesture {
                            self.service.changePage(page.pageNo)
                        }
                        .font(.system(size: 10))
                }
            }
            .padding(8)
        }.padding(10)
    }
}
```

Fairly self explanatory for you now! I used an SF Symbol circle for each of pages we have in our service. The foreground color uses a ternary to check if the circle position is the same as the active page, and if it is, the circle becomes white - if not, gray. 

***BAM! A GESTURE!***

Using ```.onTapGesture{}``` we can give the image an action when tapped. Here, we've simply said, change the page to the one that this circle represents! Because SF Symbol size can be controlled using ```.font```, I changed the size to be 10 - which I thought worked best. And that's it!

### Bottom Bar

<img width="373" alt="Screenshot 2021-05-03 at 15 34 03" src="https://user-images.githubusercontent.com/68400711/116889898-ff7b4180-ac24-11eb-990e-b7d63837b453.png">

Lol nice attempt at Spotify there... 

Last but not least comes the bottom bar - for want of a better name 🤦🏼. Again, fairly simple seeing as we've already made our ```IconView```!

``` swift
struct BottomBar: View {
    @EnvironmentObject var service: Service
    var body: some View {
        HStack(spacing: 20) {
            ForEach(self.service.bottomBar.icons, id:\.self) { icon in
                IconView(icon: icon, showText: false)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: self.service.iconSize * 5 / 3)
        .background(Color.darkGray)
        .opacity(0.9)
    }
}
```

The frame is just what I thought looked best in terms of size, again using the ```iconSize``` so that things change dynamically when that value changes. One thing I need to mention is this line:
``` swift
.background(Color.darkGray)
```
Here I've used a custom Color that I defined in ```Themes.swift``` which is where I put all my Colors and View Modifiers etc. The code inside ```Themes``` for this color is as follows:
``` swift 
import Foundation
import SwiftUI

extension Color {
    public static var darkGray: Color {
        return Color(red: 70 / 255 , green: 70 / 255, blue: 70 / 255)
    }
}
}
```

Make sure to import SwiftUI in order to access ```Color```!

## Gesture

So the final thing to do is tie all those elements together and create our main swiping gesture!

In our ```Main``` struct, let's add our service and then another variable which will become clear later:

``` swift
struct Main: View {
    @EnvironmentObject var service: Service
    @State var liveDrag: CGFloat = 0
    
    var body: some View {
    
    ...
```

Then let's make our body:

``` swift 
struct Main: View {
    @EnvironmentObject var service: Service
    @State var liveDrag: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0){
            ZStack {
                ForEach(self.service.pages, id: \.self) { page in
                    HomePage(pageNo: page.pageNo).environmentObject(service)
                }
            }
            
            PageScroll().environmentObject(service)
            BottomBar().environmentObject(service)
        }
        .background(
            Image("example_background")
                .resizable()
                .ignoresSafeArea()
        )
    }
}
```
So we have a VStack containing a ZStack with our pages in, our ```PageScroll``` and the ```BottomBar```. A ZStack, in case you don't know, is like a VStack or HStack but instead of rendering it's content vertically or horizontally, it renders them on-top of each other. I defined the background here too which you can grab from the assets [folder](https://github.com/edbarnes01/SwiftUI/tree/main/Walkthroughs/Gestures/Gestures/Assets.xcassets/example_background.imageset) or use your own!

This is good but we need the ```HomePage``` views inside the ZStack to be side by side and not on-top of each other. We can do this by adding an offset in the x axis using the screen width and page number. Here's what that looks like represented visually:
<img width="929" alt="Screenshot 2021-05-03 at 16 09 32" src="https://user-images.githubusercontent.com/68400711/116894675-3ef85c80-ac2a-11eb-9249-e3a081155e13.png">

And in code adding two lines, one to HomePage and one to the ZStack istelf:

``` swift
var body: some View {
    VStack(spacing: 0){
        ZStack {
            ForEach(self.service.pages, id: \.self) { page in
                HomePage(pageNo: page.pageNo).environmentObject(service)
                .offset(x: CGFloat(page.pageNo) * UIScreen.main.bounds.width, y: 0)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .offset(x: -CGFloat(self.service.activePage) * UIScreen.main.bounds.width, y: 0)

        PageScroll().environmentObject(service)
        BottomBar().environmentObject(service)
    }
    .background(
        Image("example_background")
            .resizable()
            .ignoresSafeArea()
    )
}
```

I also defined the width of our ZStack to be the screen width. ***REMEMBER*** that the ZStack offset needs to be negative because you're moving all 3 pages in order to display the correct one in the viewport.

## Swipe Gesture

Well that was a lot of buildup, hats off if you stayed with me for all that. 
Our gesture needs to do two things:
- Drag the page in real time
- Switch pages when the drag ends if certain conditions are met

With that in mind, inside our ```body```, let's create a new gesture and cover the first bullet point:

``` swift 
let HomeSwipeGesture = DragGesture()
    .onChanged { change in
        self.liveDrag = change.translation.width
    }
```

Remember our variable ```liveDrag``` - well we use our ```.onChanged{}``` along with defining the result of the gesture as ```change``` to assign it the value of the gesture's translation in the x-axis. That's the realtime drag covered! Now for when we stop dragging. 
Ideally, our gesture will check wether we've swiped left or right and then check wether there is a page to the left or right to swap to, before resetting the realtime drag so that our new page sits nicely centre frame. 
So the three possible outcomes of the drag gesture:
- Swiped left and there is a page after the current one
- Swiped right and there is a page before the current one
- Neither of these conditions were met 

Here's my code for this model!
``` swift
let HomeSwipeGesture = DragGesture()
    .onChanged { change in
        self.liveDrag = change.translation.width
    }
    .onEnded { change in
        if change.translation.width < 0 && self.service.activePage < self.service.pages.count - 1 {
            withAnimation(.easeOut(duration: 0.2)) {
                self.service.changePage(self.service.activePage + 1)
                self.liveDrag = 0
            }

        }
        if change.translation.width > 0 && self.service.activePage > 0 {
            withAnimation(.easeOut(duration: 0.2)) {
                self.service.changePage(self.service.activePage - 1)
                self.liveDrag = 0
            }
        }
        withAnimation(.easeOut(duration: 0.4)) {
            self.liveDrag = 0
        }
    }
```

By using ```withAnimation()```, we can animate any views that will change as a result of the action inside it. And using easeOut means that the animation starts instantly but stops gradually. 

Perfect! Now all that's left to do is add the liveDrag value as an offset to the ZStack showing our page.

``` swift
ZStack {
    ForEach(self.service.pages, id: \.self) { page in
        HomePage(pageNo: page.pageNo).environmentObject(service)
            .offset(x: CGFloat(page.pageNo) * UIScreen.main.bounds.width, y: 0)
            .gesture(HomeSwipeGesture)
    }
}

.frame(width: UIScreen.main.bounds.width)
.offset(x: -CGFloat(self.service.activePage) * UIScreen.main.bounds.width, y: 0)
.offset(x: self.liveDrag, y: 0)
```

There you have it! Hope you've enjoyed this walkthrough and it's helped you out or shown you something useful! As always, please go ahead and give me love or hate below! Feedback is essential for improvement. Be sure to check out my other walkthroughs if you enjoyed!
