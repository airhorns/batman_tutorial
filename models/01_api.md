!SLIDE center
# Models

!SLIDE center

    class Product extends Batman.Model

!SLIDE

# Domain Logic

    class Shopify.Order extends Batman.Model
      calculateTotal: ->
        @get('lineItems').reduce (a,b) ->
          a.get('cost') + b.get('cost')

    order = new Shopify.Order()
    order.calculateTotal()

.notes Models like in Rails are classes and I say this is where all your domain/business logic goes. Use them to encapsulate the whole deal
!SLIDE center

# Boo

!SLIDE center

![backbone](backbone.png)

!SLIDE bullets incremental

# Domain <del>Logic</del> Data

    class Shopify.Order extends Batman.Model
      @accessor 'total', ->
        @get('lineItems').reduce (a,b) ->
          a.get('cost') + b.get('cost')

    order = new Shopify.Order()
    order.get('total')

 - Now if any `LineItem`'s cost changes, or if the `lineItems` collection changes, the total will be updated.

!SLIDE

# Validations

<pre><code class="longerer">
class Shopify.Product extends Batman.Model
  @validate 'name', presence: true
  @validate 'cost',
    presence: true
    numeric: true
    greaterThan: 0
</code></pre>

!SLIDE

# State Machine based

    (new Shopify.Product).get('state')
    #=> 'new'

!SLIDE center bullets incremental

# Transactions

 - Pending ...

 - <p class="small">na ha</p>

!SLIDE

# Associations

<pre><code class="longer">
class Shopify.Product extends Batman.Model
  @belongsTo 'shop'

class Shopify.Shop extends Batman.Model
  @hasMany 'products', autoload: false
</code></pre>

.notes High five Kamil!
