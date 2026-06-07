#!/usr/bin/env ruby
# frozen_string_literal: true

# Brewfile Pretty Printer
# Parses a Brewfile and outputs it with organized sections

# Part 1: Brewfile Parser (mirrors Brewfile DSL)
class BrewfileParser
  Package = Struct.new(:type, :name, :options)

  SIMPLE_TYPES = { brew: :brews, cask: :casks, vscode: :vscode, go: :go, npm: :npm, cargo: :cargo, uv: :uv }.freeze

  def initialize
    @packages = {
      taps: [],
      brews: [],
      casks: [],
      mas: [],
      vscode: [],
      go: [],
      cargo: [],
      uv: [],
      npm: [],
    }
  end

  def parse(file_path)
    instance_eval(File.read(file_path), file_path)
    @packages
  end

  def tap(name, url = nil, **options)
    parts = [url && "\"#{url}\""] + options.map { |k, v| "#{k}: #{v.inspect}" }
    @packages[:taps] << Package.new(:tap, name, parts.compact.empty? ? nil : parts.compact.join(', '))
  end

  def mas(name, id:, **options)
    extra = options.map { |k, v| "#{k}: #{v.inspect}" }
    @packages[:mas] << Package.new(:mas, name, { id: id, extra: extra })
  end

  SIMPLE_TYPES.each do |type, key|
    define_method(type) do |name, **options|
      @packages[key] << Package.new(type, name, opts_str(options))
    end
  end

  private

  def opts_str(options)
    options.empty? ? nil : options.map { |k, v| "#{k}: #{v.inspect}" }.join(', ')
  end
end

# Part 2: Categorization DSL
class CategoryConfig
  attr_reader :groups

  def initialize
    @groups = {}
    @current_group = nil
  end

  def group(name, &block)
    @current_group = name
    @groups[name] ||= []
    instance_eval(&block)
    @current_group = nil
  end

  def pkg(name)
    raise "pkg must be called within a group block" unless @current_group
    @groups[@current_group] << name
  end

  def self.configure(&block)
    config = new
    config.instance_eval(&block)
    config.groups
  end
end

# Part 3: Brewfile Formatter
class BrewfileFormatter
  UNCATEGORIZED_SECTIONS = %i[mas vscode go cargo uv npm].freeze

  def initialize(packages, categories)
    @packages = packages
    @categories = categories

    @name_to_category = {}
    @categories.each { |group, pkgs| pkgs.each { |p| @name_to_category[p] = group } }

    @categorized_brews = Hash.new { |h, k| h[k] = [] }
    @categorized_casks = Hash.new { |h, k| h[k] = [] }

    categorize_packages
  end

  def categorize_packages
    @packages[:brews].each { |pkg| @categorized_brews[find_category(pkg.name)] << pkg }
    @packages[:casks].each { |pkg| @categorized_casks[find_category(pkg.name)] << pkg }
  end

  def find_category(name)
    @name_to_category.fetch(name, "Others")
  end

  def generate
    output = []

    @packages[:taps].sort_by(&:name).each { |pkg| output << format_package(pkg) }

    ordered_groups = @categories.key?("Others") ? @categories.keys : @categories.keys + ["Others"]
    ordered_groups.each do |group|
      brews = @categorized_brews[group]
      casks = @categorized_casks[group]

      next if brews.empty? && casks.empty?

      output << ""
      output << "# #{group}"
      brews.sort_by(&:name).each { |pkg| output << format_package(pkg) }
      casks.sort_by(&:name).each { |pkg| output << format_package(pkg) }
    end

    UNCATEGORIZED_SECTIONS.each do |type|
      pkgs = @packages[type]
      next if pkgs.empty?
      output << ""
      pkgs.sort_by(&:name).each { |pkg| output << format_package(pkg) }
    end

    output << "# vim: ft=ruby"
    output << ""

    output.join("\n")
  end

  private

  def format_package(pkg)
    case pkg.type
    when :mas
      parts = ["id: #{pkg.options[:id]}"] + Array(pkg.options[:extra])
      "mas \"#{pkg.name}\", #{parts.join(', ')}"
    else
      pkg.options ? "#{pkg.type} \"#{pkg.name}\", #{pkg.options}" : "#{pkg.type} \"#{pkg.name}\""
    end
  end
end

# CONFIGURATION (DSL)
CATEGORIES = CategoryConfig.configure do
  group "Essential" do
    pkg "chezmoi"
    pkg "age"
    pkg "age-plugin-yubikey"
    pkg "atuin"
    pkg "direnv"
    pkg "fd"
    pkg "fnox"
    pkg "fzf"
    pkg "gh"
    pkg "git-delta"
    pkg "git-extras"
    pkg "git-lfs"
    pkg "mas"
    pkg "topgrade"
    pkg "ripgrep"
    pkg "jnv"
    pkg "jq"
    pkg "lsd"
    pkg "ouch"
    pkg "starship"
    pkg "sheldon"
    pkg "zoxide"
    pkg "xh"
    pkg "macos-trash"
    pkg "mise"
    pkg "ghostty"
  end

  group "Recommended" do
    pkg "bitwarden-cli"
    pkg "ast-grep"
    pkg "bat"
    pkg "d2"
    pkg "difftastic"
    pkg "dufs"
    pkg "jj"
    pkg "git-cliff"
    pkg "lazygit"
    pkg "lazyjj"
    pkg "yazi"
    pkg "lazyssh"
    pkg "ut"
    pkg "jwt-ui"
    pkg "aerospace"
    pkg "appcleaner"
    pkg "atuin-desktop"
    pkg "bruno"
  end

  group "Languages and Development Tools" do
    pkg "cmake"
    pkg "php"
    pkg "composer"
    pkg "gleam"
    pkg "cargo-dist"
    pkg "go"
    pkg "ruff"
    pkg "zig"
    pkg "uv"
    pkg "pipx"
    pkg "biome"
    pkg "pomsky"
    pkg "ruby"
    pkg "python@3.11"
    pkg "openjdk"
    pkg "bun"
    pkg "android-platform-tools"
    pkg "android-studio"
  end
end

# Main execution
if __FILE__ == $PROGRAM_NAME
  input_file = ARGV[0] || "Brewfile"

  unless File.exist?(input_file)
    warn "Error: File '#{input_file}' not found"
    exit 1
  end

  packages = BrewfileParser.new.parse(input_file)
  formatter = BrewfileFormatter.new(packages, CATEGORIES)
  puts formatter.generate
end
