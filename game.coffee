######################################################################
class Game
    constructor: ->
        @game = new JSGameSoup($("#game")[0], 30)
        
    add: (entity) ->
        @game.addEntity(entity)
        this
        
    del: (entity) ->
        @game.delEntity(entity)
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
        
        launch_distance = 5
        
        # Launch
        @x_acc = (Math.random() - 0.5) * 2 * launch_distance
        @y_acc = (Math.random() - 0.5) * 2 * launch_distance
    
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
            
            g.del(this);
            
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
        @max_radius = 50
        @population = 0
    
    update: ->
        population_increase =  1;
        increase_chance = Math.random()
        
        if (Math.random() <= (@radius / @max_radius))
            @population += population_increase
    
    draw: (c) ->
        c.fillStyle = 'red'
        # Draw Planet Co-ord
        c.fillText("(#{@x}, #{@y})", @x - 22, @y + @radius + 12);
        # Draw
        c.beginPath();
        c.arc(@x, @y, @radius, 0, Math.PI*2, true); 
        c.closePath();
        c.fill();
        c.fillStyle = 'white'
        # Draw planet population
        c.fillText(@population, @x - 6, @y + @radius + (12 * 2));

######################################################################
######################################################################    
######################################################################

g = new Game();

p1 = new Planet(100, 100, 20);
p2 = new Planet(500, 200, 40);
p3 = new Planet(70,  170, 10);
p4 = new Planet(700, 600, 15);

g.add(p1).add(p2).add(p3).add(p4);

s1 = new Squadron(100, 100, 75);
s2 = new Squadron(500, 200, 25);
s3 = new Squadron(70,  170, 5);
s4 = new Squadron(700, 600, 10);

s1.aimFor(500, 200, g)
s2.aimFor(70,  170, g)
s3.aimFor(700, 600, g)
s4.aimFor(100, 100, g)

g.start();
