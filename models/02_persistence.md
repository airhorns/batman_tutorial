!SLIDE center
# Persistence

<pre><code class="longer">
class Alfred.Todo extends Batman.Model
  @persist Batman.LocalStorage

class LiamNeeson.Enemy extends Batman.Model
  @persist Batman.RestStorage

class Shopify.Product extends Batman.Model
  @persist Batman.RailsStorage
</code></pre>

!SLIDE center

# Querying

!SLIDE center

# Async

!SLIDE center

![ugh](Ugh.jpg)

Ugh

!SLIDE center

# Its really not that bad once you get used to it.

!SLIDE

# Like RSpec.

<p class="small">If Tobi isn't in the room, ignore this slide</p>


!SLIDE

    Todo.find 1, (err, todo) ->
      throw err if err
      alert todo.get('text')

!SLIDE

    Todo.load (err, todos) ->
      throw err if err
      todos.forEach (todo) ->
        tode.set('done', true)

    Todo.load {limit: 10}, (err, todos) ->
      throw err if err
      ok todos.length <= 10

!SLIDE

    todo = new Todo(text: "stop the joker")
    todo.save (err) ->
      throw err if err
      ok todo.get('id')?

!SLIDE

    todo.load (err, potentiallyNewTodo) ->
      throw err if err

.notes The identity map! The record you call the method on isn't necessarily the one you will get back in the callback.

!SLIDE

    todo.destroy (err) ->
      throw err if err

!SLIDE

# Associations

!SLIDE

    class Shopify.Shop extends Batman.Model
      @hasMany 'products', autoload: false

    products = shop.get('products')

    ok products.length == 0

    products.load (err, products) ->
      throw err if err
      ok products.length != 0

