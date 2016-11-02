Phaser = require 'Phaser'

config = require './config.coffee'
Boot = require './boot.coffee'
Preload = require './preload.coffee'
Menu = require './menu.coffee'
Game = require './game.coffee'

game = new Phaser.Game config.width, config.height, Phaser.AUTO, 'game-stage'
game.state.add 'Boot', Boot
game.state.add 'Preload', Preload
game.state.add 'Menu', Menu
game.state.add 'Game', Game
game.state.start 'Boot'