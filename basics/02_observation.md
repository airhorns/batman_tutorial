!SLIDE center

# Batman #

.notes What does all this strife earn us

!SLIDE center

# Observation

!SLIDE

<pre><code class="longer">
shop.observe 'title', (newTitle, oldTitle) ->
  console.log(newTitle)
shop.set 'title', "Gadget Emporium"
# "Gadget Emporium" logged to the console.
</code></pre>

!SLIDE image center

![satisfaction](100_Satisfaction_Guarantee.png)

.notes Because you use get and set, you can be assured your observers will be fired when the value they observe changes

!SLIDE center

# This works with objects.

!SLIDE

<pre><code class="longer">
shop.observe 'products.length', (newLength) ->
  console.log(newLength)
shop.set 'products', []
# "0" logged to the console.
</code></pre>

!SLIDE

# And deep objects

!SLIDE

<pre><code class="longerer">
product.observe 'variants.first.name', (newName) ->
  console.log newName

oldVariants = product.get('variants')

product.set 'variants.first.title', 'thread count'
#= 'thread count'

product.set 'variants', [new Variant(title: 'color')]
#=> 'color' logged to the console.

product.set 'variants', oldVariants
#=> 'size' logged to the console.

product.set 'variants', []
#=> 'undefined' logged to the console.

</code></pre>

.notes Notice how even though the keypath descends through many segments, it still fires if any of the segments change. The objects title changed, the object changed, and the collection changed, and the observer fires each time.

!SLIDE

# Batman

.notes Cool. James made this.

