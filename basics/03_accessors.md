!SLIDE center

# Accessors

!SLIDE center

# In Ruby, you can redefine assignment. You can't in JavaScript.

!SLIDE center

    shop.set('title', "Gadget Emporium")

.notes Luckily, all assignments in Batman go through set.

!SLIDE center

# You can define custom getters and setters

!SLIDE

<pre><code class="longer">
customer.accessor 'fullName'

  get: ->
    @get('firstName') + " " + @get('lastName')

  set: (_, v) ->
    [first, last] = v.split ' '
    @set 'firstName', first
    @set 'lastName', last
</code></pre>

!SLIDE center

# Hey thats cool.

!SLIDE center

# What about the guarantee?

!SLIDE

# Accessors observe their dependencies and eagerly recalculate when they change.

!SLIDE

    customer = new Customer
      firstName: "Thomas"
      lastName: "Wayne"

    customer.observe 'fullName', (name) ->
      console.log name

    customer.set firstName 'Bruce'
    # "Bruce Wayne" logged to the console

.notes Note that we observed the 'fullName' property, and set one of its depencies, and the observer fired. In batman terminology, the properties of objects which an accessor depends on to caculate its value are called sources.

!SLIDE cetner bullets incremental

 - sources can be from any Batman object, not the object with the accessor on it
 - accessors can run requests and do sets later to implement lazy fetching of server side data
 - accessors can use keypaths and thus list all the segments as sources
 - accessor values can be cached

!SLIDE center

# Caveats

!SLIDE center bullets incremental

 - accessor bodies have to be deterministic (branching is ok though)
 - accessors can get run pretty often so they it sucks if they are expensive
 - its easier than normal to leak memory

!SLIDE

# I miss `method_missing`

!SLIDE

# Batman allows "default accessors" which are close

!SLIDE

    class Model
      @accessor
        get: (key) -> @_attributes[k]
        set: (key, value) -> @_attributes[k] = value
        unset: (key) delete @_attributes[k]

!SLIDE

# Client code won't know the difference.

.note Allows for some awesome decoupling between property access vs storage implementations or side effects (like dirty key tracking or access counts)
