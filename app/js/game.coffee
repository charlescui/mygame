Phaser = require 'Phaser'

class Game extends Phaser.State
  constructor: -> super

  update: ->
    if @input.activePointer.justPressed()
      @state.start 'Menu'

module.exports = Game