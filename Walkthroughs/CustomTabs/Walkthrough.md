<!-- CUSTOM TABS -->
# Custom Tabs

Hi all! In this walkthrough I’ll be talking about custom Tabs and how I like to implement them into my apps. I'll cover the functionality behind page navigation and creating the custom tabs.

* [Preview](#preview)

* [Intro](#intro)
* [Page Navigation](#page-navigation)
* [The Tabs](#the-tabs)

## Preview

https://user-images.githubusercontent.com/68400711/116890981-1e2e0800-ac26-11eb-8770-27a276042bca.mov

## Intro 
Before we start there are a few things to consider. As in most occasions, I am going to start by creating a “Service”, and if you don’t know what I mean when I say that, please look [here](https://github.com/edbarnes01/SwiftUI/tree/main/BeforeYouRead#service). We need our page navigation functionality and current page variable to be inside the service so that we can access and change the page from different views. So let’s begin by designing the service!

## Page Navigation
Create a new swift file and name it “Service”. Then let’s define a new class “Service” and make it conform to the ObservableObject protocol. 

``` swift
class Service: ObservableObject {

}
```
This will allow us to use it as an environment object which will allow views to receive updates from the variables inside it (eg. A current page variable!). So let’s create a current page variable that can be changed to show the page we want. I like to create Enumeration variables for page navigation, because they are exhaustive and we won’t get any strange values that you may accidentally change it to when using a string for example. Bug-proofing (he says with slight apprehension)! Here’s what this enum (for short) may look like for a shop app:

``` swift 
enum Page {
    case home
    case search
    case basket
    case account
}
```

So now we have our page enum that defines our pages which the tabs will select! If at any point, you want a new tab, just add it to the enum here. I also want to say the enum doesn’t have to be declared in the Service file, but I like having it in here for context in case anyone else needs to read your code. Next, we will make a @Published variable called currentPage and the type will be our enum we just created. Make sure to initialise it! I will set it to home.  

``` swift
class Service: ObservableObject {
    @Published var currentPage: Page = .home
}
```

@Published is an important wrapper here and if you’re not sure what it does, please look [here](https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-published-property-wrapper).

And then we need a function to change the page which we will use when the tab buttons are tapped! This is also useful because there may be times in an app where maybe you’d want to force a page upon the user, for example.

So I’m going to create a function named changePage() and that will take an argument page which will be of type pages (our enum). I’m also going to add an underscore before the argument name which means we don’t have to type that bit when we call our function.

``` swift 
class Service: ObservableObject {
    @Published var currentPage: Page = .home
    
    func changePage(_ page: Page) {
        self.currentPage = page
    }
}
```

Cool, we’re all set!

## The Tabs

Now, let’s go to our main app file. Note: I am using the newest version of Xcode at the time of writing this blog so I am using the SwiftUI lifecycle. 

<img width="412" alt="SwiftUILifeCycle" src="https://user-images.githubusercontent.com/68400711/116545000-c3c03f00-a8e7-11eb-9e8c-7dfe03b6a13c.png">

Moving on swiftly - oh that’s appalling. Moving on, we need an instance of our service that we will use as an environment object. It’s important you use a lower case “service” when defining your variable. Generally, it’s good Swift practice for classes and structs to be defined with UpperCamelCase and variables, lowerCamelCase. Put this in the main app file.

So we will say:

``` swift
@main
struct CustomTabsApp: App {
    var service = Service()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

As you can see we have a file called ContentView which is called directly from the main app file. Now I’m going to delete this and add SwiftUI files called “Container” and “Main”. If you’d like to understand why, please check this out.

Let’s open up container, and within the “Container” struct, we will make a variable that we can pass our service to:

``` swift
struct Container: View {
    @EnvironmentObject var service: Service
    var body: some View {
        Text("Hello World!")
    }
}
``` 

Now jump back into our app file and we’re gonna send the service object variable we created to the “Container” view as an environment object like this:

``` swift 
@main
struct CustomTabsApp: App {
    var service = Service()
    var body: some Scene {
        WindowGroup {
            Container().environmentObject(service)
        }
    }
}
```

Perfect! Now our Container can access our service and this is useful for things like checking the user is logged for example. So seeing as we don’t have to deal with that, let’s just add our “Main” view into the body and once again, pass it our environment object instance. 

``` swift 
struct Container: View {
    @EnvironmentObject var service: Service
    var body: some View {
        Main().environmentObject(service)
    }
}
```

We now need to create a new SwiftUI file for every tab/page we intend to add!

Now open “Main”. Here is where the fun starts! Here we need to check what the current page is and display the correct view. We’re going to use a switch statement to achieve this. If you’re unfamiliar with a switch statement, it’s essentially the same as a lot of if statements but clearer and easier to read (I’m sure there are other differences but time is money, eh?). So we will pass our currentPage variable from service into the switch statement and show the corresponding view. First, define our environment variable again and then this is the switch statement could look:

``` swift
struct Main: View {
    @EnvironmentObject var service: Service
    var body: some View {
        switch self.service.currentPage {
            case .home:
                Home()
            case .search:
                Search()
            case .basket:
                Basket()
            case .account:
                Account()
        }
    }
}
```
And now we can see the benefits of using an enum for currentPage, there is no default option required for the switch statement for if it receives some strange value. It will never receive a strange value because currentPage has to be one of the cases in our enum we defined! I loved learning that.

So we have:

- Created a service 
- Added a currentPage variable and page change function
- Created our tab’s view logic

Now let’s do the tabs! My preference for tabs is to have a tab bar and tab buttons as separate structs. Go ahead and create a SwiftUI file called “TabBar”. Let’s add this to main at the bottom of a VStack, with a spacer separating it from the page switch statement. Don’t forget to pass it our service.

``` swift 
struct Main: View {
    @EnvironmentObject var service: Service
    var body: some View {
        VStack {
            switch self.service.currentPage {
                case .home:
                    Home()
                case .search:
                    Search()
                case .basket:
                    Basket()
                case .account:
                    Account()
            }
            Spacer()
            TabBar().environmentObject(service)
        }
    }
}
```

Open up the TabBar file and underneath the TabBar struct we will create another struct named TabButton and make it conform to a view. Create a body and put some text in there to keep XCode happy. 

How the tabs will work is as follows: 

- Create a list of TabInfo objects
- For each TabInfo object, create a tab button

This keeps your tabs easy to manage, and makes adding a new page or feature easy. It’s so important to consider the scalability and readability of your code, especially when working in a team.

So with that plan in mind, in the file, I’ll create a new struct called TabInfo at the top of the file and it will have 3 variables, the name, the enum value of the page and the name of the icon (SF symbol) that we want to use for the tab. If you haven’t downloaded SF Symbols, you can do so [here](https://developer.apple.com/sf-symbols/). They are a fantastic resource. 

``` swift 
struct TabInfo {
    var name: String
    var page: Page
    var icon: String
}
```

Create a list of TabInfo objects (based on your pages enum) just beneath like so:

``` swift 
let tabs = [
    TabInfo(name: "Home", page: .home, icon: "house"),
    TabInfo(name: "Search", page: .search, icon: "magnifyingglass"),
    TabInfo(name: "Basket", page: .basket, icon: "cart"),
    TabInfo(name: "Account", page: .account, icon: "person")
]
```

Great! We have our tab data, now let’s assimilate these into a view. Within the TabButton struct, let’s add some variables:

``` swift 
struct TabButton: View {
    @EnvironmentObject var service: Service
    var activeBarHeight: CGFloat
    var isActive: Bool
    var height: CGFloat
    var width: CGFloat
    var tabInfo: TabInfo
    
    var body: some View {
        Text("Text to keep XCode happy")
    }
}
```

A quick note: activeBarHeight is the height of the little blue bar that will be shown when the tab is active and isActive will be true if the tab is the current page.

Let’s make the button. All we really need is the icon in a VStack with a spacer either side. We then want to show a little bar if that tab is active so we’ll add this if statement too.

``` swift 
 var body: some View {
        VStack {
            if isActive {
                Rectangle()
                    .frame(height: activeBarHeight)
                    .foregroundColor(.blue)
                    .shadow(color: .blue, radius: 4)
            }
            Spacer()
            Image(systemName: tabInfo.icon)
            Spacer()
        }
   }
```

We want this VStack to be clipped so that the shadow doesn’t escape the bounds. And then we want to add a gesture so that when the user taps on our tab button, the change function that we passed will be triggered. I also added animation to this action, which will mean any view that is updated by the change will transition to its new state via the animation we give it. And finally we want the size of this tab button to be the width we pass it and for the height we’ll use a ternary statement so that the frame is the correct size depending on wether it is showing the active bar or not. I love using SwiftUI’s layout tools such as Spacer() and Padding() but using defined values also leaves nothing to chance.

``` swift 
struct TabButton: View {
    @EnvironmentObject var service: Service
    var activeBarHeight: CGFloat
    var isActive: Bool
    var height: CGFloat
    var width: CGFloat
    var tabInfo: TabInfo
    
    
    var body: some View {
        VStack {
            if isActive {
                Rectangle()
                    .frame(height: activeBarHeight)
                    .foregroundColor(.blue)
                    .shadow(color: .blue, radius: 4)
            }
            Spacer()
            Image(systemName: tabInfo.icon)
            Spacer()
        }
        .clipped()
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                self.service.changePage(tabInfo.page)
            }
        }
        .frame(width: width, height: isActive ? height + activeBarHeight : height)
    }
}
```

Now we need to go into TabBar. First, define our service variable. Before we write the ForEach statement, we need some properties to pass to each button: the height, width and active bar height. Keeping these variables together and at a higher level makes it easier to modify if needs be. Here is how I defined these:

``` swift 
@EnvironmentObject var service: Service
let tabHeight: CGFloat = 50
let tabWidth = UIScreen.main.bounds.width / CGFloat(tabs.count)
let activeBarHeight: CGFloat =  2
```

Okay, sweet. Let’s now add a ForEach statement within an HStack and set the spacing to 0 with the alignment being .bottom. In a ForEach, every item within the array you pass to the loop must be identifiable (have some unique key). Sometimes its best to have a variable called id within the objects you’re iterating over, or sometimes you can just declare “self” and say "each item will be unique, I promise". This is what I’m doing here.

``` swift 
struct TabBar: View {
    @EnvironmentObject var service: Service
    let tabHeight: CGFloat = 50
    let tabWidth = UIScreen.main.bounds.width / CGFloat(tabs.count)
    let activeBarHeight: CGFloat =  2
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(tabs, id:\.self) { tab in
             
            }
        }
    }
}
```

Xcode will then inform you that TabInfo needs to conform to hashable. Let's make it conform then! 

``` swift 
struct TabInfo: Hashable {
    var name: String
    var page: Page
    var icon: String
}
```

Use the tab info to fill in the blanks for a TabButton initialiser and make sure to pass it the service!

``` swift 
struct TabBar: View {
    @EnvironmentObject var service: Service
    let tabHeight: CGFloat = 50
    let tabWidth = UIScreen.main.bounds.width / CGFloat(tabs.count)
    let activeBarHeight: CGFloat =  2
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(tabs, id:\.self) { tab in
                TabButton(activeBarHeight: activeBarHeight,
                          isActive: self.service.currentPage == tab.page,
                          height: tabHeight,
                          width: tabWidth,
                          tabInfo: tab)
                    .environmentObject(service)
            }
        }
    }
}
```
And that’s that! Any questions or any seriously disgruntled angry messages, please leave them in the comments below!

