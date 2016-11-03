Phaser = require 'Phaser'

class Game extends Phaser.State
  constructor: () ->
    super
    @power = 300

  init: ->
    @game.renderer.renderSession.roundPixels = true
    @game.world.setBounds(0, 0, 992, 480)
    @physics.startSystem(Phaser.Physics.ARCADE)
    @physics.arcade.gravity.y = 200

  preload: ->
    # We need this because the assets are on Amazon S3
    # Remove the next 2 lines if running locally
    # @load.baseURL = 'http://files.phaser.io.s3.amazonaws.com/codingtips/issue001/'
    # @load.crossOrigin = 'anonymous'

    @load.image('tank', 'assets/img/tank.png')
    @load.image('turret', 'assets/img/turret.png')
    @load.image('bullet', 'assets/img/bullet.png')
    @load.image('background', 'assets/img/background.png')
    @load.image('flame', 'assets/img/flame.png')
    @load.image('target', 'assets/img/target.png')

  create: ->
    # @ Simple but pretty background
    @background = @add.sprite(0, 0, 'background')
    # @ Something to shoot at :)
    @targets = @add.group(@game.world, 'targets', false, true, Phaser.Physics.ARCADE)
    @targets.create(300, 390, 'target')
    @targets.create(500, 390, 'target')
    @targets.create(700, 390, 'target')
    @targets.create(900, 390, 'target')
    # @ Stop gravity from pulling them away
    @targets.setAll('body.allowGravity', false)
    # @ A single bullet that the tank will fire
    @bullet = @add.sprite(0, 0, 'bullet')
    @bullet.exists = false
    @physics.arcade.enable(@bullet)
    # @ The body of the tank
    @tank = @add.sprite(24, 383, 'tank')
    # @ The turret which we rotate (offset 30x14 from the tank)
    @turret = @add.sprite(@tank.x + 30, @tank.y + 14, 'turret')
    # @ When we shoot this little flame sprite will appear briefly at the end of the turret
    @flame = @add.sprite(0, 0, 'flame')
    @flame.anchor.set(0.5)
    @flame.visible = false
    # @ Used to display the power of the shot
    @power = 300
    @powerText = @add.text(8, 8, 'Power: 300', { font: "18px Arial", fill: "#ffffff" })
    @powerText.setShadow(1, 1, 'rgba(0, 0, 0, 0.8)', 1)
    @powerText.fixedToCamera = true
    # @ Some basic controls
    @cursors = @input.keyboard.createCursorKeys()
    @fireButton = @input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)
    @fireButton.onDown.add(@fire, this)

  fire: ->
    if @bullet.exists
      return
    # //  Re-position the bullet where the turret is
    @bullet.reset(@turret.x, @turret.y)
    # //  Now work out where the END of the turret is
    p = new Phaser.Point(@turret.x, @turret.y)
    p.rotate(p.x, p.y, @turret.rotation, false, 34)
    # //  And position the flame sprite there
    @flame.x = p.x
    @flame.y = p.y
    @flame.alpha = 1
    @flame.visible = true
    # //  Boom
    @add.tween(@flame).to( { alpha: 0 }, 100, "Linear", true)
    # //  So we can see what's going on when the bullet leaves the screen
    @camera.follow(@bullet)
    # //  Our launch trajectory is based on the angle of the turret and the power
    @physics.arcade.velocityFromRotation(@turret.rotation, @power, @bullet.body.velocity)

  hitTarget: (bullet, target) ->
    target.kill()
    @removeBullet()

  removeBullet: ->
    @bullet.kill()
    @camera.follow()
    @add.tween(@camera).to( { x: 0 }, 1000, "Quint", true, 1000)

  update: ->
    if @input.activePointer.justPressed()
      @state.start 'Menu'
    # //  If the bullet is in flight we don't let them control anything
    if (@bullet.exists)
      if (@bullet.y > 420)
        # //  Simple check to see if it's fallen too low
        @removeBullet()
      else
        # //  Bullet vs. the Targets
        @physics.arcade.overlap(@bullet, @targets, @hitTarget, null, this)
    else
      # //  Allow them to set the power between 100 and 600
      if (@cursors.left.isDown && @power > 100)
        @power -= 2
      else if (@cursors.right.isDown && @power < 600)
        @power += 2

      # //  Allow them to set the angle, between -90 (straight up) and 0 (facing to the right)
      if (@cursors.up.isDown && @turret.angle > -90)
        @turret.angle--
      else if (@cursors.down.isDown && @turret.angle < 0)
        @turret.angle++

      # //  Update the text
      @powerText.text = 'Power: ' + @power

module.exports = Game