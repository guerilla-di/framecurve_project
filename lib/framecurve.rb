class Framecurve
  VERSION = '1.0.0'
  
  class MinimumSourceFrameIsOneError < RuntimeError
  end
  
  class NonSequentialDestinationFrameError < RuntimeError
  end
  
end

require File.dirname(__FILE__)  + "/emitter"
require File.dirname(__FILE__)  + "/curve"
