######################################################################
class Game
    constructor: ->
        @game = new JSGameSoup($("#game")[0], 30)
        
    add: (entity) ->
        @game.addEntity(entity)
        this
    
    start: ->
        @game.launch();

######################################################################
class Moveable
    constructor: (@x, @y) ->
        @x_acc = 0
        @y_acc = 0
    
    aimFor: (x, y) ->
        @aim_x = x
        @aim_y = y
        
        # Launch
        @x_acc = (Math.random() - 0.5) * 2 * 10
        @y_acc = (Math.random() - 0.5) * 2 * 10
    
    update: ->
        change = 0.25
        dist_x = Math.abs(@x - @aim_x)
        dist_y = Math.abs(@y - @aim_y)
        
        if (@x < @aim_x)
            @x_acc += change
        else if (@x > @aim_x)
            @x_acc -= change
            
        if (@y < @aim_y)
            @y_acc += change
        else if (@y > @aim_y)
            @y_acc -= change
            
        if (dist_x < 100)
            @x_acc *= 0.95
            
        if (dist_y < 100)
            @y_acc *= 0.95
            
        if (dist_x < 10 && dist_y < 10)
            @x_acc = 0
            @y_acc = 0
            @x = @aim_x
            @y = @aim_y
            
        @x += Math.round(@x_acc)
        @y += Math.round(@y_acc)

######################################################################
class Ship extends Moveable
    constructor: (x, y) ->
        super(x, y)
        @radius = 2
    
    draw: (c) ->
        c.fillStyle = 'white'
        c.fillText("(#{@x}, #{@y})", @x - 22, @y + 12);
        c.beginPath();
        c.arc(@x, @y, @radius, 0, Math.PI*2, true); 
        c.closePath();
        c.fill();

######################################################################
class Squadron
    constructor: (@x, @y, @count) ->
        
    aimFor: (x, y, game) ->
        ( ship = new Ship(@x, @y); ship.aimFor(x, y); game.add(ship); ) for i in [0 .. @count]

######################################################################
class Planet
    constructor: (@x, @y, @radius) ->
    
    update: ->
    
    draw: (c) ->
        c.fillStyle = 'red'
        c.fillText("(#{@x}, #{@y})", @x - 22, @y + @radius + 12);
        c.beginPath();
        c.arc(@x, @y, @radius, 0, Math.PI*2, true); 
        c.closePath();
        c.fill();

######################################################################
######################################################################    
######################################################################

g = new Game();

p1 = new Planet(100, 100, 20);
p2 = new Planet(500, 200, 40);

g.add(p1).add(p2);

s = new Squadron(100, 100, 75);

s.aimFor(500, 200, g)

g.start();
