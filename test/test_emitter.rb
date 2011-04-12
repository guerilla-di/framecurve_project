require "test/unit"
require "framecurve"
require "stringio"

class TestEmitter < Test::Unit::TestCase
  def setup
    @io = StringIO.new
    @emitter = Framecurve::Emitter.new(@io)
  end
  
  def test_emit_whole
    @emitter.write_frame(1, 123)
    @emitter.write_frame(2, 124)
    @emitter.write_frame(3, 125)
    # File.open("./test_export.framecurve.txt", "w"){|f| f.write(@io.string) }
    assert_equal @io.string, File.read("./test_export.framecurve.txt"), "Should produce the same file"
  end
  
  def test_emitter_raises_when_negative_source_frame_is_used
    @emitter.write_frame(1, 123)
    assert_raise(Framecurve::MinimumSourceFrameIsOneError) { @emitter.write_frame(1, -123) }
  end
  
  def test_emitter_raises_when_source_frame_less_than_one_is_used
    @emitter.write_frame(1, 123)
    assert_raise(Framecurve::MinimumSourceFrameIsOneError) { @emitter.write_frame(1, 0.3) }
  end

  def test_emitter_raises_when_source_frame_less_than_one_is_used
    @emitter.write_frame(1, 123)
    assert_raise(Framecurve::FrameAlreadyWritten) { @emitter.write_frame(1, 124) }
  end
  
end
