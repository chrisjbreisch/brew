# frozen_string_literal: true

require "extend/ENV"
require "fcntl"
require "socket"
require "os/universal_server"

module OS
  class UniversalServer
    def self.open
      Dir.mktmpdir("homebrew", HOMEBREW_TEMP) do |tmpdir|
        server = UNIXServer.open("#{tmpdir}/socket")
        ENV["HOMEBREW_ERROR_PIPE"] = server.path

        return server unless block_given?

        yield server
      end
    end
  end
end
