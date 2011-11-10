!SLIDE center

# All property access is done using `get` and `set`.

!SLIDE center

    shop.products

!SLIDE center

<pre><code><del>shop.products</del></code></pre>

!SLIDE center

    shop.get('products')

!SLIDE center

    shop.orders.first.total.round(2)

!SLIDE center

<pre><code><del>shop.orders.first.total.round(2)</del></code></pre>

!SLIDE

    shop
      .get('orders')
      .get('first')
      .get('total')
      .round(2)

.notes This is what you now have to do with get

!SLIDE center

# BATMAN

!SLIDE center

# Batman

!SLIDE

    shop.get('orders.first.total').round(2)

!SLIDE

# Keypaths

!SLIDE bullets incremental

# Chain them as deep as you want, it works similarly to Ruby's `try(:method)`

 - `Foo.get('will.never.exist.but.its.ok')`

!SLIDE bullets

# `set` must be done the same way

!SLIDE center

    shop.name = "Alfred's Gadget Emporium"

!SLIDE center

<pre><code><del>shop.name = "Alfred's Gadget Emporium"</del></code></pre>

!SLIDE center

    shop.set "name", "Bat Gadget Emporium"

!SLIDE center

    shop.orders.first.total = 0

!SLIDE center

    shop.set 'orders.first.total', 0
