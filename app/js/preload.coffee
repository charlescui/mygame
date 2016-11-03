Parse = require 'Parse'
Phaser = require 'Phaser'

config = require './config.coffee'

class Preload extends Phaser.State
  constructor: -> super

  preload: ->
    # Show loading screen
    @load.setPreloadSprite @add.sprite @game.world.centerX - 160, @game.world.centerY - 16, 'preloadBar'

    # Set up game defaults
    @stage.backgroundColor = 'black'

    # Load game assets
    @load.pack 'main', config.pack

  create: ->
    @state.start 'Menu'

module.exports = Preload