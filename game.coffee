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
    
    aimFor: (x, y) ->
        @aim_x = x
        @aim_y = y
    
    update: ->
        if (@x < @aim_x)
            @x++
        else if (@x > @aim_x)
            @x--
            
        if (@y < @aim_y)
            @y++
        else if (@y > @aim_y)
            @y--

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

s = new Ship(100, 100);
p1 = new Planet(100, 100, 20);
p2 = new Planet(500, 200, 40);

s.aimFor(500, 200);

g.add(p1).add(p2);
g.add(s);

g.start();
