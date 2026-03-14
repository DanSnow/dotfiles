#!/usr/bin/env ruby
# frozen_string_literal: true

# Brewfile Pretty Printer
# Parses a Brewfile and outputs it with organized sections

# Part 1: Brewfile Parser (mirrors Brewfile DSL)
class BrewfileParser
  Package = Struct.new(:type, :name, :options)

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
    content = File.read(file_path)
    instance_eval(content, file_path)
    @packages
  end

  # Mirror Brewfile DSL methods
  def tap(name)
    @packages[:taps] << Package.new(:tap, name, nil)
  end

  def brew(name, **options)
    options_str = options.empty? ? nil : options.map { |k, v| "#{k}: #{v}" }.join(', ')
    @packages[:brews] << Package.new(:brew, name, options_str)
  end

  def cask(name)
    @packages[:casks] << Package.new(:cask, name, nil)
  end

  def mas(name, id:)
    @packages[:mas] << Package.new(:mas, name, id)
  end

  def vscode(extension_id)
    @packages[:vscode] << Package.new(:vscode, extension_id, nil)
  end

  def go(package_path)
    @packages[:go] << Package.new(:go, package_path, nil)
  end

  def npm(package_path)
    @packages[:npm] = Package.new(:npm, package_path, nil)
  end

  def cargo(package_path)
    @packages[:cargo] << Package.new(:cargo, package_path, nil)
  end

  def uv(package_path)
    @packages[:uv] << Package.new(:uv, package_path, nil)
  end
end

# Part 2: Categorization DSL
class CategoryConfig
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

  def groups
    @groups
  end

  def self.configure(&block)
    config = new
    config.instance_eval(&block)
    config.groups
  end
end

# Part 3: Brewfile Formatter
class BrewfileFormatter
  def initialize(packages, categories)
    @packages = packages
    @categories = categories
    @categorized_brews = {}
    @categorized_casks = {}

    # Initialize category arrays
    @categories.each_key do |group|
      @categorized_brews[group] = []
      @categorized_casks[group] = []
    end
    @categorized_brews["Others"] = []
    @categorized_casks["Others"] = []

    categorize_packages
  end

  def categorize_packages
    # Categorize brews
    @packages[:brews].each do |pkg|
      category = find_category(pkg.name)
      @categorized_brews[category] << pkg
    end

    # Categorize casks
    @packages[:casks].each do |pkg|
      category = find_category(pkg.name)
      @categorized_casks[category] << pkg
    end
  end

  def find_category(name)
    @categories.each do |group, packages|
      return group if packages.include?(name)
    end
    "Others"
  end

  def generate
    output = []

    # Taps at the top
    @packages[:taps].sort_by(&:name).each do |pkg|
      output << format_tap(pkg)
    end

    # Process each category
    ordered_groups = @categories.keys + ["Others"]
    ordered_groups.uniq.each do |group|
      brews = @categorized_brews[group]
      casks = @categorized_casks[group]

      next if brews.empty? && casks.empty?

      output << ""
      output << "# #{group}"

      brews.sort_by(&:name).each do |pkg|
        output << format_brew(pkg)
      end

      casks.sort_by(&:name).each do |pkg|
        output << format_cask(pkg)
      end
    end

    # mas, vscode, go (ungrouped)
    unless @packages[:mas].empty?
      output << ""
      @packages[:mas].sort_by(&:name).each do |pkg|
        output << format_mas(pkg)
      end
    end

    unless @packages[:vscode].empty?
      output << ""
      @packages[:vscode].sort_by(&:name).each do |pkg|
        output << format_vscode(pkg)
      end
    end

    unless @packages[:go].empty?
      output << ""
      @packages[:go].sort_by(&:name).each do |pkg|
        output << format_go(pkg)
      end
    end

    unless @packages[:cargo].empty?
      output << ""
      @packages[:cargo].sort_by(&:name).each do |pkg|
        output << format_cargo(pkg)
      end
    end

    unless @packages[:uv].empty?
      output << ""
      @packages[:uv].sort_by(&:name).each do |pkg|
        output << format_uv(pkg)
      end
    end

    unless @packages[:npm].empty?
      output << ""
      @packages[:npm].sort_by(&:name).each do |pkg|
        output << format_npm(pkg)
      end
    end

    output << "# vim: ft=ruby"
    output << ""

    output.join("\n")
  end

  private

  def format_tap(pkg)
    "tap \"#{pkg.name}\""
  end

  def format_brew(pkg)
    if pkg.options
      "brew \"#{pkg.name}\", #{pkg.options}"
    else
      "brew \"#{pkg.name}\""
    end
  end

  def format_cask(pkg)
    "cask \"#{pkg.name}\""
  end

  def format_mas(pkg)
    "mas \"#{pkg.name}\", id: #{pkg.options}"
  end

  def format_vscode(pkg)
    "vscode \"#{pkg.name}\""
  end

  def format_go(pkg)
    "go \"#{pkg.name}\""
  end

  def format_cargo(pkg)
    "cargo \"#{pkg.name}\""
  end

  def format_uv(pkg)
    "uv \"#{pkg.name}\""
  end

  def format_npm(pkg)
    "npm \"#{pkg.name}\""
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
