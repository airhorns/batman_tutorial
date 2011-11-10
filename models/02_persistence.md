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

.notes You can also pass options to the class level load which depending on the storage adapter will be used to filter/modify the results

!SLIDE

    todo = new Todo(text: "stop the joker")
    todo.save (err) ->
      throw err if err
      ok todo.get('id')?

.notes Saving works like you are used to, just async

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

    class Todo extends Batman.Model
      @belongsTo 'author'

    todo = new Todo
    todo.get('author')

.notes This is what defining an association looks like. You use the same functions-on-the-class style system in the class body to define the relationships, and this sets up the accessors for the associations.

!SLIDE

    class Todo extends Batman.Model
      @belongsTo 'author'

    todo = Todo.find 1, (err, todo) ->
      throw err if err

      todo.observe 'author.name', (name) ->
        console.log name

      # => "undefined" logged to the console
      # wait...
      # => "Bruce" logged to the console

.notes If your API is like Shopify's and sends out the associated records embedded in the JSON, you are laughing. Otherwise, Batman will fetch them for you when you ask.

!SLIDE

    class Shopify.Shop extends Batman.Model
      @hasMany 'products', autoload: false

    products = shop.get('products')

    ok products.length == 0

    products.load (err, products) ->
      throw err if err
      ok products.length != 0

.notes Again similar to rails, the associated objects returned have the ability to reload themselves. This works across all types of associations.

!SLIDE

# Encoders

!SLIDE center

# This one is easy

!SLIDE center bullets

- To define what fields get persisted to and from the server you must define 'encoders' and 'decoders' for them

!SLIDE center

# Its a whitelist

!SLIDE

    class Product extends Batman.Model
      @encode 'name', 'cost'

.notes This specifies that when Batman either goes to create the JSON representation, or interpret the JSON representation, it should look for the fields 'name' and 'cost' and use them as the occur in either JSON land or JS land to go into the other

!SLIDE

    class Shop extends Batman.Model
      @encode 'settings'
        encode: (value) ->
          JSYAML.dump(value)
        decode: (value) ->
          JSYAML.parse(value)

.notes This specifies that we should use the imaginary library JSYAML to dump and parse a YAML serialized field in the JSON. I realize this would never happen.

!SLIDE

    class Product extends Batman.Model
      @encode 'created_at', 'updated_at',
        Batman.Encoders.railsDate

.notes Batman has a few built in encoders to make thing easier on you, so you can pass references to the objects instead of using object literals like above.

!SLIDE

# Batman

