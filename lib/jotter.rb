# frozen_string_literal: true

require "pathname"
require "thor"
require_relative "jotter/version"

# Provides jotter implementation
module Jotter
  BASE_COLOR = "\e[0m"
  PASS_COLOR = "\e[1;32m"

  # Provides CLI implementation
  class CLI < Thor
    # Class public methods
    desc "help [COMMAND]", "Describes cli command"

    def help(command = nil)
      super
    end

    desc "new NOTE", "Creates a new MD note"
    option :path, type: :string, aliases: "-p", desc: "Path to note location"

    def new(note)
      exit Jotter.new(note, options[:path])
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
  def self.new(note, root)
    @root = Pathname.new(root).expand_path if root
    name = note_name(note)
    path = path_name(name)
    log_message(__method__, "adding new entry to #{path}")
    res = (File.exist?(path) || update_file?(path, "w", title_text(name))) &&
          update_file?(path, "a", entry_text)
    res ? 0 : 1
  end

  def self.setup
    @root = Pathname.new("~/Documents/Markdown/note-repository").expand_path
  end

  def self.version
    puts "#{PASS_COLOR}version: #{Jotter::VERSION}#{BASE_COLOR}"
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
    File.basename(note, ".*").sub(/^\d{8}_/, "").gsub(/[^0-9A-Za-z.-]/, "-")
  end

  def self.path_name(name)
    path = @root.join("#{Time.now.strftime("%Y%m%d")}_#{name.downcase(:ascii)}.md")
    path.tap { |p| p.dirname.mkpath }
  end

  def self.entry_text
    "\nEntry Content\n"
  end

  def self.title_text(name)
    formatted_name = name.split("-").map(&:capitalize).join(" ")
    "# #{Time.now.strftime("%Y%m%d")} #{formatted_name}\n\n #inbox\n"
  end

  def self.update_file?(file, mode, data)
    file.open(mode) { |f| f << data }
    true
  rescue StandardError => e
    log_exception(__method__, "modifying #{file} failed: ", e)
    false
  end

  private_class_method(:log_exception, :log_message, :note_name, :path_name, :entry_text, :title_text, :update_file?)
end
