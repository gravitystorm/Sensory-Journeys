# Code for simplifying a list of Tracepoints. Based on code by Joel Rosenberg
#
# Original License: You may distribute this code under the same terms as Ruby itself
#
# Original Author: Joel Rosenberg

module DpSimplify
  class LineString
  @@dp_threshold = 0.00001
  
  def simplify( points )
  
    #
    # This is an implementation of the Douglas-Peucker algorithm for simplifying
    # a line. You can thing of it as an elimination of points that do not
    # deviate enough from a vector. That threshold for point elimination is in
    # @@dp_threshold. See
    #
    #   http://everything2.com/index.pl?node_id=859282
    #
    # for an explanation of the algorithm
    #
    
    max_dist = 0  # Greatest distance we measured during the run
    stack = []
    distances = Array.new(points.size)
  
    if(points.length > 2)
      stack << [0, points.size-1]
      
      while(stack.length > 0) 
        current_line = stack.pop()
        p1_idx = current_line[0]
        pn_idx = current_line[1]
        pb_dist = 0
        pb_idx = nil
        
        x1 = points[p1_idx][:longitude]
        y1 = points[p1_idx][:latitude]
        x2 = points[pn_idx][:longitude]
        y2 = points[pn_idx][:latitude]
        
        # Caching the line's magnitude for performance
        magnitude = Math.sqrt((x2 - x1)**2 + (y2 - y1)**2)
        magnitude_squared = magnitude ** 2
        
        # Find the farthest point and its distance from the line between our pair
        for i in (p1_idx+1)..(pn_idx-1)
        
          # Refactoring distance computation inline for performance
          #current_distance = compute_distance(points[i], points[p1_idx], points[pn_idx])
          
          # 
          # This uses Euclidian geometry. It shouldn't be that big of a deal since
          # we're using it as a rough comparison for line elimination and zoom
          # calculation.
          #
          # TODO: Implement Haversine functions which would probably bring this to
          #       a snail's pace (ehhhh)
          #
    
          px = points[i][:longitude]
          py = points[i][:latitude]
         
          current_distance = nil
          
          if( magnitude == 0 )
            # The line is really just a point
            current_distance = Math.sqrt((x2-px)**2 + (y2-py)**2)
          else
         
            u = (((px - x1) * (x2 - x1)) + ((py - y1) * (y2 - y1))) / magnitude_squared
            
            if( u <= 0 || u > 1 )
                # The point is closest to an endpoint. Find out which one
                ix = Math.sqrt((x1 - px)**2 + (y1 - py)**2)
                iy = Math.sqrt((x2 - px)**2 + (y2 - py)**2)
                if( ix > iy )
                  current_distance = iy
                else
                  current_distance = ix
                end
            else
                # The perpendicular point intersects the line
                ix = x1 + u * (x2 - x1)
                iy = y1 + u * (y2 - y1)
                current_distance = Math.sqrt((ix - px)**2 + (iy - py)**2)
            end
          end
          
          # See if this distance is the greatest for this segment so far
          if(current_distance > pb_dist)
            pb_dist = current_distance
            pb_idx = i
          end
        end
        
        # See if this is the greatest distance for all points
        if(pb_dist > max_dist)
          max_dist = pb_dist
        end
        
        if(pb_dist > @@dp_threshold)
          # Our point, Pb, that had the greatest distance from the line, is also
          # greater than our threshold. Process again using Pb as a new 
          # start/end point. Record this distance - we'll use it later when
          # creating zoom values
          distances[pb_idx] = pb_dist
          stack << [p1_idx, pb_idx]
          stack << [pb_idx, pn_idx]
        end
        
      end
    end
    
    # Force line endpoints to be included (sloppy, but faster than checking for
    # endpoints in encode_points())
    distances[0] = max_dist
    distances[distances.length-1] = max_dist
  
    output = []
    
    for i in 0..(points.size() - 1)
      if( distances[i] != nil )
        output << points[i]
      end
    end

    return output
    
  end
end
end