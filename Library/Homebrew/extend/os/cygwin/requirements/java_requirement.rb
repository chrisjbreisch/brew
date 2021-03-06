# frozen_string_literal: true

require "language/java"

class JavaRequirement < Requirement
  env do
    env_java_common
    env_oracle_jdk
  end

  private

  def oracle_java_os
    :windows
  end
end
