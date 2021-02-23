class MovementX extends EmitterX

  count: 0
  isPressed: {}

  # ---

  constructor: ->
    super()

    for key in ['w', 'a', 's', 'd']
      $.on key, => @check key, 'down'
      $.on "#{key}:up", => @check key, 'up'

  check: (key, action) ->

    if action == 'down' and @isPressed[key]
      return
    else if action == 'up' and !@isPressed[key]
      return

    count = @checkMove()

    if count and !@count
      player.emit 'move-start'
    else if !count and @count
      player.emit 'move-end'

    @count = count

  checkMove: ->

    count = 0

    for key in ['w', 'a', 's', 'd']

      if $.getState key

        count = count + 1

        if @isPressed[key]
          continue
        @isPressed[key] = true

        $.press "#{key}:down"

      else

        unless @isPressed[key]
          continue
        @isPressed[key] = false

        $.press "#{key}:up"

    return count

  resetKey: ->

    for key, value of @isPressed
      unless value
        continue
      $.press "#{key}:up"

    return @

# execute

movement = new MovementX()

player
  .on 'move-start', ->
    if player.isMoving
      return
    player.isMoving = true
  .on 'move-end', ->
    unless player.isMoving
      return
    player.isMoving = false