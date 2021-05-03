<!-- CUSTOM TABS -->
## Gestures

Hi all! In this walkthrough I’ll be talking about gestures and how you can use them to create cool effects. This project focuses on the ```DragGesture()``` (but also includes ```.onTapGesture{}```). I decided a cool way to show you how this could work would be to recreate a home screen. This produced some interesting results... I rather like using SF Symbols instead of the normal icons for these apps 👀. Anyway, without further delay, let's jump in!

* [Preview](#preview)
* [Intro](#intro)
* [Setup](#setup)
* [ICreating The Pages](#creating-the-pages)
* [Gesture](#gesture)

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

So with a LazyVGrid, we need to define the layout for the cells in our grid. For a VGrid, the cells will be organised in Columns and for an HGrid, rows. Within the ```columns:``` parameter, you can tell SwiftUI your layout preferences. For this project, I went with adaptive cells (```.adaptive()```) but you could also used fixed sizes as well. However, i did ant to specify that the cells should always be at least as big as our icon size we defined in our service. 

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


