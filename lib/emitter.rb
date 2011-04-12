# Writer for framecurve files that also validates frames and ensures everything is formatted exactly the way it should be
class Framecurve::Emitter
  COMPAT_LINEBREAK = "\r\n"
  
  h = <<EOF
# This is a framecurve file representing a timewarp,
# The first column is the frame in the scene, the second column
# is the frame that needs to be used from the original video or
# the original animation. A tab is between the columns and linebreaks are CRLF.
# Destination frames are always listed sequentially.
# We assume that the FIRST frame of source animation/video is frame 1 (so frames are one-based)
# at_frame    use_frame
EOF
  HEADER = h.gsub(/\n/, "\r\n").gsub(/    /, "\t")
  FRAME_TEMPLATE = "%d\t%0.5f\r\n"
  
  def initialize(to_io)
    @io, @header_written, @min_frame = to_io, false, nil
  end
  
  def write_frame(to_frame_i, from_frame_f)
    raise Framecurve::MinimumSourceFrameIsOneError if from_frame_f < 0.999 # Float safety!
    raise Framecurve::NonSequentialDestinationFrameError if @min_frame && (to_frame_i < @min_frame)
    
    @header_written ||= write_header
    @min_frame = to_frame_i
    @io.write(FRAME_TEMPLATE % [to_frame_i, from_frame_f])
  end
  
  # Emit a Framecurve::Curve object through this Emitter
  def emit_curve(curve)
    curve.each{|a, b| write_frame(a, b) }
  end
  
  private
  
  def write_header
    @io.write(HEADER)
  end
end
