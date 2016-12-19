class Escualo::Session

  def clean_environment_variables!
    tell! Escualo::Env.clean_command
  end

  def setup_environment_variables!
    source_escualorc = "'source ~/.escualorc'"
    tell_all! 'mkdir -p ~/.escualo/vars',
              %q{echo 'for var in ~/.escualo/vars/*; do source $var; done' > ~/.escualorc},
              %q{chmod u+x ~/.escualorc},
              "grep -q #{source_escualorc} ~/.bashrc || echo #{source_escualorc} >> ~/.bashrc"
  end

  def set_environment_variables!(variables)
    tell_all! *variables.map { |key, value| Escualo::Env.set_command key, value }
  end

  def unset_environment_variables!(variable_names)
    tell_all! *variable_names.map { |name| Escualo::Env.unset_command name }
  end
end