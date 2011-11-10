!SLIDE center

# Objects

!SLIDE bullets incremental

# Modules (Mixins in Batman jargon)

 - Observable (gives `get`, `set`, `observe`)
 - EventEmitter (gives `fire`, `prevent`, `allow`)
 - Enumerable (gives `filter`, `reduce` given `forEach`)

!SLIDE bullets incremental

# Pretty much everything in the Batman world descends from `Batman.Object`

    class Batman.Object
      $mixin @::, Batman.Observable
      $mixin @::, Batman.EventEmitter

 - The `@::` means "this class' prototype"

!SLIDE bullets incremental

# Core Classes

 - Batman.Object
 - Batman.Set
 - Batman.SetSort and Batman.SetIndex
 - Batman.Hash
 - Batman.Request
 - Batman.StateMachine

!SLIDE bullets incremental

# Subclassing

!SLIDE
<pre><code class="longer">
class CoolObject extends Batman.Object
</code></pre>

!SLIDE

<pre><code class="longer">
class CoolObject extends Batman.Object
  @accessor 'awesomeness', -> 10
</code></pre>

!SLIDE

<pre><code class="longer">
class CoolObject extends Batman.Object
  @accessor 'awesomeness', -> 10

  @observeAll 'awesomeness', (newAwesomeness) ->
</code></pre>

!SLIDE

<pre><code class="longer">
class CoolObject extends Batman.Object
</code></pre>


<pre><code class="longer">
CoolObject.accessor 'awesomeness', -> 10

CoolObject.observeAll 'awesomeness', (x) ->
</code></pre>

!SLIDE
<pre><code class="longer">
class CoolObject extends Batman.Object
  @observe 'awesomeness', ->
</code></pre>

!SLIDE

<pre><code class="longer">
CoolObject.observe 'awesomeness', (x) ->
</code></pre>

!SLIDE

# Gotcha

!SLIDE

# Classes are <del>people</del> objects too.

!SLIDE

<pre><code class="longer">
class SomeClass extends Batman.Object

SomeClass.observe 'awesomeness', (x) ->
  console.log x

SomeClass.set 'awesomeness', 10
# => "10" logged to the console

</code></pre>

