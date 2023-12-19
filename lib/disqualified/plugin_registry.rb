# typed: strict

class Disqualified::PluginRegistry
  include TSort
  extend T::Sig

  sig { void }
  def initialize
    @ordering = T.let({}, T::Hash[String, T::Array[String]])
    @registered = T.let({}, T::Hash[String, Disqualified::Plugin])
  end

  ONE_PLUS_PLUGINS = T.type_alias { T.any(String, T::Array[String]) }

  sig { params(plugin: Disqualified::Plugin, after: ONE_PLUS_PLUGINS, before: ONE_PLUS_PLUGINS).void }
  def register(plugin, after: [], before: [])
    @registered[plugin.name] = plugin
    order(plugin.name, after:, before:)
  end

  sig { params(plugin_name: String, after: ONE_PLUS_PLUGINS, before: ONE_PLUS_PLUGINS).void }
  def order(plugin_name, after: [], before: [])
    @ordering[plugin_name] ||= []
    @ordering[plugin_name].push(*after)
    [].push(*before).each do |dependant|
      @ordering[dependant] ||= []
      T.must(@ordering[dependant]).push(plugin_name)
    end
  end

  sig { params(block: T.proc.params(arg0: String).void).void }
  def tsort_each_node(&block)
    @ordering.each do |key, _|
      next unless @registered.key?(key)
      block.call(key)
    end
  end

  sig { params(node: String, block: T.proc.params(arg0: String).void).void }
  def tsort_each_child(node, &block)
    @ordering.fetch(node).each do |dependency|
      next unless @registered.key?(dependency)
      block.call(dependency)
    end
  end

  sig { returns(T::Array[String]) }
  def sorted
    tsort
  end

  sig { returns(T::Array[Disqualified::Plugin]) }
  def sorted_plugins
    tsort.map do |plugin_name|
      @registered.fetch(plugin_name)
    end
  end

  private :tsort
end
