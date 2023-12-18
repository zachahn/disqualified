# typed: strict

class Disqualified::Cron
  extend T::Sig

  sig { void }
  def initialize
    @registry = T.let(Registry.new, Registry)
  end

  sig { params(block: T.proc.params(arg0: Disqualified::Cron::Registry).void).void }
  def register(&block)
    yield @registry
  end
end
