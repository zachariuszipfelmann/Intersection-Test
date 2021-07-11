require "app/vector.rb"
require "app/collision.rb"


class Game

  attr_gtk


  def tick
    if state.tick_count == 0
      defaults
      calc
      render
    end
  end 


  def defaults
    BACKGROUND_COLOR ||= {r: 0, g: 48, b: 59}
    
    COLLIDER_COLOR_NORMAL ||= {r: 241, g: 242, b: 218}
    
    COLLIDER_COLOR_INTERSECT ||= {r: 255, g: 206, b: 150}
    
    COLLIDERS ||= [Collider.new([[670, 460], [800, 480], [940, 540], [870, 660], [710, 570]]),
      Collider.new([[100, 130], [300, 190], [340, 460], [240, 650]]),
      Collider.new([[510, 410], [620, 500], [630, 630], [490, 600]]),
      Collider.new([[510, 80], [800, 150], [670, 310], [500, 210]]),
      Collider.new([[910, 30], [1060, 50], [1040, 150], [900, 220]]),
      Collider.new([[340, 220], [410, 280], [250, 300]]),
      Collider.new([[240, 330], [410, 300], [440, 460]]),
      Collider.new([[520, 300], [780, 280], [760, 380]]),
      Collider.new([[1020, 270], [1200, 620], [870, 590]])
    ]
    
    state.collider_colors ||= Array.new(size = COLLIDERS.length, default = COLLIDER_COLOR_NORMAL)
  end


  def calc
    COLLIDERS.each_with_index do |first_collider, index|
      COLLIDERS.reject{|collider| collider == first_collider}.each do |other_collider|
        if first_collider.intersects(other_collider)
          state.collider_colors[index] = COLLIDER_COLOR_INTERSECT
        end
      end
    end
  end
  

  def render
    outputs.background_color = BACKGROUND_COLOR.values

    COLLIDERS.each_with_index do |collider, index|
      collider.points.each_cons(2) do |points|
        line = {x: points[0][0],
          y: points[0][1],
          x2: points[1][0],
          y2: points[1][1]
        }.merge(state.collider_colors[index])

        outputs.static_lines << line
      end

      line = {x: collider.points.first[0],
        y: collider.points.first[1],
        x2: collider.points.last[0],
        y2: collider.points.last[1]
      }.merge(state.collider_colors[index])

      outputs.static_lines << line
    end
  end
end


def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end
