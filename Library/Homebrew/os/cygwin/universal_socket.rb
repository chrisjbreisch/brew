# frozen_string_literal: true

require "extend/ENV"
require "socket"

module OS
  class UniversalSocket
    def self.open
      port = ENV["HOMEBREW_ERROR_PIPE"].to_i
      socket = TCPSocket.new("127.0.0.1", port)

      return socket unless block_given?

      yield socket
    end
  end
end
