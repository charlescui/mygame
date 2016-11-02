Phaser = require 'Phaser'

class Menu extends Phaser.State
  constructor: -> super

  create: ->
    logo = @add.sprite @game.world.centerX, @game.world.centerY, 'phaserLogo'
    logo.anchor.setTo 0.5, 0.5

    @song = @add.audio 'gameMusic'
    @song.play '', 0, 1, true  # Loop

  update: ->
    if @input.activePointer.justPressed()
      @song.stop()
      @state.start 'Game'

module.exports = Menu