# frozen_string_literal: true

old_trap = trap("INT") { exit! 130 }

require "global"
require "extend/ENV"
require "timeout"
require "debrew"
require "formula_assertions"
require "fcntl"
require "socket"
require "os/universal_socket"

TEST_TIMEOUT_SECONDS = 5 * 60

begin
  error_pipe = OS::UniversalSocket.open

  ENV.extend(Stdenv)
  ENV.setup_build_environment

  trap("INT", old_trap)

  formula = ARGV.resolved_formulae.first
  formula.extend(Homebrew::Assertions)
  formula.extend(Debrew::Formula) if ARGV.debug?

  # tests can also return false to indicate failure
  Timeout.timeout TEST_TIMEOUT_SECONDS do
    raise "test returned false" if formula.run_test == false
  end
rescue Exception => e # rubocop:disable Lint/RescueException
  error_pipe.puts e.to_json
  error_pipe.close
  pid = Process.pid.to_s
  if which("pgrep") && which("pkill") && system("pgrep", "-qP", pid)
    $stderr.puts "Killing child processes..."
    system "pkill", "-P", pid
    sleep 1
    system "pkill", "-9", "-P", pid
  end
  exit! 1
end
