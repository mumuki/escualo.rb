class Mumukit::Core::Template
  def initialize(path, variables)
    @path = path
    variables.each do |key, value|
      instance_variable_set "@#{key}", value
    end
  end

  def render
    template_file.result binding
  end

  def write!(file)
    File.write! file, render
  end

  private

  def template_file
    ERB.new File.read(path)
  end
end
