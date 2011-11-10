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

