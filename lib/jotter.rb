# frozen_string_literal: true

require "thor"
require_relative "jotter/version"

# Provides jotter implementation
module Jotter
  # Provides CLI implementation
  class CLI < Thor
    # Class public methods
    desc "help [COMMAND]", "Describes cli command"

    def help(command = nil)
      super
    end

    desc "new NOTE", "Creates a new MD note"

    def new(note)
      exit Jotter.new(note)
    end

    desc "version", "Prints version number"

    def version
      exit Jotter.version
    end

    no_commands do
      def self.exit_on_failure?
        true
      end

      def self.start(given_args = ARGV, config = {})
        Jotter.setup
        super
      end
    end
  end

  # Module public methods
  def self.new(note)
    name = note_name(note)
    path = path_name(name)
    log_message(__method__, "adding new entry to #{path}")
    res = (File.exist?(path) || update_file?(path, "w", title(name))) &&
          update_file?(path, "a", section)
    res ? 0 : 1
  end

  def self.setup
    @root = Pathname.new("~/Developer/Tests/").expand_path
  end

  def self.version
    puts Jotter::VERSION
    0
  end

  # Module private methods
  def self.log_exception(method_name, message, exp)
    puts "#{name}:#{method_name} #{message} #{exp.message}"
  end

  def self.log_message(method_name, message)
    puts "#{name}:#{method_name} #{message}"
  end

  def self.note_name(note)
    File.basename(note, ".md").sub(/^\d{8}_/, "").gsub(/[^0-9A-Za-z.-]/, "-")
  end

  def self.path_name(name)
    path = @root.join("#{Time.now.strftime("%Y%m%d")}_#{name}.md")
    path.tap { |p| p.dirname.mkpath }
  end

  def self.section
    "\n\n## #{Time.now.strftime("%H%M")} "
  end

  def self.title(name)
    formatted_name = name.split("-").map(&:capitalize).join(" ")
    "# #{Time.now.strftime("%Y%m%d")} #{formatted_name}"
  end

  def self.update_file?(file, mode, data)
    file.open(mode) { |f| f << data }
    true
  rescue StandardError => e
    log_exception(__method__, "modifying #{file} failed: ", e)
    false
  end

  private_class_method(:log_exception, :log_message, :note_name, :path_name, :section, :title, :update_file?)
end
