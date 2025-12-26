require "mars_rover_alvin/version"

module MarsRoverAlvin

  class Rover

  GRID_X = 5
  GRID_Y = 5

    def initialize(x_coordinate, y_coordinate, cardinal_point)
      @x_coordinate = x_coordinate.to_i
      @y_coordinate = y_coordinate.to_i
      @cardinal_point= cardinal_point
    end

    # 'L' in nasa commands

    def turn_left
      if @cardinal_point == 'N' then @cardinal_point = 'W'
      elsif @cardinal_point == 'W' then @cardinal_point = 'S'
      elsif @cardinal_point == 'S' then @cardinal_point = 'E'
      elsif @cardinal_point == 'E' then @cardinal_point = 'N'
      end
    end

    # 'R' in nasa commands

    def turn_right
      if @cardinal_point == 'N' then @cardinal_point = 'E'
      elsif @cardinal_point == 'E' then @cardinal_point = 'S'
      elsif @cardinal_point == 'S' then @cardinal_point = 'W'
      elsif @cardinal_point == 'W' then @cardinal_point = 'N'
      end
    end

    # 'M' in nasa commands
    def move
      if @cardinal_point == 'N' then @y_coordinate += 1
      elsif @cardinal_point == 'E' then @x_coordinate += 1
      elsif @cardinal_point == 'S' then @y_coordinate -= 1
      elsif @cardinal_point == 'W' then @x_coordinate -= 1
      end
    end

    def parse(instruction)
      instruction.each_char do |char|
        if char == 'L'
          self.turn_left
        elsif char == 'R'
          self.turn_right
        elsif char == 'M'
          self.move
          if @x_coordinate > GRID_X || @y_coordinate > GRID_Y 
            puts "Your Rover has reached the upper limit of the grid"
            abort
          elsif @x_coordinate < 0 || @y_coordinate < 0 
            puts "Your Rover has reached the lower limit of the grid"
            abort          
          end         
        end   
      end
    end

    def current_position
      puts "Your rover is at this #{@x_coordinate} #{@y_coordinate} #{@cardinal_point} location"
    end
    
  end
end
