# typed: strict

module Disqualified::Plugin
  extend T::Sig
  extend T::Helpers
  abstract!

  sig { abstract.returns(String) }
  def name
  end

  sig { abstract.returns(String) }
  def job_config_namespace
  end

  sig { abstract.returns(String) }
  def metadata_namespace
  end

  sig { overridable.void }
  def on_registry
  end

  sig do
    overridable
      .params(
        metadata: T.untyped,
        job_options: Disqualified::Options,
        arguments: T.untyped
      )
      .void
  end
  def before_queue(metadata:, job_options:, arguments:)
  end

  sig { overridable.params(record: Disqualified::Record).void }
  def before_finish(record:)
  end
end
