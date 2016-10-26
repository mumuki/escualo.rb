class Mumukit::Core::Template
  attr_accessor :path

  def initialize(path, variables)
    @path = path
    variables.each do |key, value|
      instance_variable_set "@#{key}", value
      self.singleton_class.class_eval { attr_reader key }
    end
  end

  def render
    template_file.result binding
  end

  def write!(file)
    File.write file, render
  end

  def with_tempfile!(prefix)
    file = Tempfile.new(prefix)
    write! file
    yield file
  ensure
    file.unlink
    file.close
  end

  private

  def template_file
    ERB.new File.read(path)
  end
end
