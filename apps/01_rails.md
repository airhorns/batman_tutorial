!SLIDE center

# Apps

.notes Lets talk about doing something with all these tools


!SLIDE center

# `batman-rails`

.notes Thanks John.

!SLIDE bullets center

 - `rails g batman:install`
 - `rails g batman:controller Products`
 - `rails g batman:scaffold Products`
 - `rails g batman:model Product name:string`
 - `rails g batman:helper product`

!SLIDE center

# Batman is expressly designed for Rails developers

!SLIDE center

# Thats you

.notes Batman uses very similar concepts to Rails because they are good and because you are already comfortable with them. Routing works similarly, There's still models, controllers, views. Instead of helpers there are filters, and theres not so much templating, but we'll get to that. If there are concepts you struggle with, let us know, because its supposed to be the easiest for people like you.

!SLIDE bullets center

# Structure

.notes Some purely practical stuff here

!SLIDE

    |~app/
    | |~assets/
    | | |+images/
    | | |~javascripts/
    | | | |+controllers/
    | | | |+helpers/
    | | | |+models/
    | | | |+views/
    | | | |-application.js.coffee
    | | | `-liam_neeson.js.coffee
    | | `+stylesheets/
    | |+controllers/
    | |+helpers/
    | |+mailers/
    | |+models/
    | `+views/

.notes We've been using Sprockets to great success, and this is what a basic Batman app structure looks like. The whole client app lives in app/assets/javascripts. Haven't quite figured out where to put views, right now they are in there too.

