class Framecurve::Curve
  
  include Enumerable
  
  def initialize(frames = [])
    @frames = []
    frames.each{|a, b| keyframe!(a, b) }
  end
  
  def keyframe!(at_frame, use_frame)
    at_frame, use_frame = at_frame.to_i, use_frame.to_f
    validate_frame!(at_frame, use_frame)
    @frames << [at_frame, use_frame]
  end
  
  def each(&blk)
    @frames.each(blk)
  end
  
  def to_curve_with_intraframes
    self
  end
  
  private
  
  def validate_frame!(at_frame_i, from_frame_f)
    raise Framecurve::MinimumSourceFrameIsOneError if from_frame_f < 0.999 # Float safety!
    if @frames.any?
      raise Framecurve::NonSequentialDestinationFrameError if @frames[-1][0] > at_frame_i
    end 
  end
end