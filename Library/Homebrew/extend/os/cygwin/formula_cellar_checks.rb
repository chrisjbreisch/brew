# frozen_string_literal: true

module FormulaCellarChecks
  def valid_library_extension?(filename)
    generic_valid_library_extension?(filename) || filename.basename.to_s.include?(".dll")
  end
end