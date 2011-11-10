!SLIDE center

# Controllers

!SLIDE center

![dhh](dhh.jpg)

!SLIDE

<pre><code class="longerer">
class AdsController extends Batman.Controller
  index: (params) ->
    @set 'ads', Ad.get('all')

  show: (params) ->
    @set 'ad', Ad.find params.id, 10, (err) ->
      throw err if err
</code></pre>

!SLIDE

<pre><code class="longerer">
class AdsController extends Batman.Controller
  new: (params) ->
    @set 'ad', new Ad()

  create: (params) =>
    @get('ad').save (err) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        .flashSuccess "Ad #{@get('ad.title')} created successfully!"
        @redirect '/ads'
</code></pre>

!SLIDE

<pre><code class="longerer">
class AdsController extends Batman.Controller
  edit: (params) ->
    @set 'ad', Ad.find params.id, (err) ->
      throw err if err

  update: ->
    @get('ad').save (err) =>
      if err
        throw err unless err instanceof Batman.ErrorsSet
      else
        .flashSuccess "Ad #{@get('ad.title')} updated successfully!"
        @redirect '/ads'
</code></pre>

!SLIDE center

# There's an implict render like in Rails. Explicitly call `@render()` to pass it custom options.

!SLIDE center

# The controller is part of the context the views render in. ivar assigns work like Rails.

!SLIDE center

# Controller actions can be 'actions' in the Rails sense, or event handlers.

!SLIDE bullets incremental

    <form
      data-formfor-ad="ad"
      data-event-submit="update">
    ...
    </form>

 - `update` is a keypath to the function on the controller

!SLIDE center

# Routes

!SLIDE

    class Classifieds extends Batman.App
      @resources 'ads'
      @root 'ads#index'
      @route '/search', 'ads#search'

!SLIDE center

![hashbang](hashbang.png)
