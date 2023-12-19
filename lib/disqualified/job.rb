# typed: strict

module Disqualified::Job
  extend T::Helpers

  module ClassMethods
    extend T::Sig

    sig { returns(Disqualified::Options) }
    private def job_options
      @job_options ||= T.let(Disqualified::Options.new, T.nilable(Disqualified::Options))
    end

    sig { params(till: Symbol, including: Symbol).void }
    private def unique(till = :until_executed, including: :arguments)
      if job_options.key?("unique")
        Kernel.raise Disqualified::Error::DuplicateSetting, "`unique` called more than once"
      end

      job_options["unique"] = {
        "till" => till,
        "including" => including,
        "handler" => T.unsafe(self).name
      }
    end

    sig { params(the_time: T.any(Time, Date, ActiveSupport::TimeWithZone), args: T.untyped).void }
    def perform_at(the_time, *args)
      metadata = {}
      before_queue_completed = T.let(false, T::Boolean)

      Kernel.catch(:abort) do
        Disqualified.server_options&.plugins&.sorted_plugins&.each do |plugin|
          plugin.before_queue(metadata:, job_options:, arguments: args)
        end
        before_queue_completed = true
      end

      return unless before_queue_completed

      Disqualified::Record.create!(
        handler: T.unsafe(self).name,
        arguments: JSON.dump(args),
        queue: "default",
        run_at: the_time,
        metadata:
      )
    end

    sig { params(args: T.untyped).void }
    def perform_async(*args)
      T.unsafe(self).perform_at(Time.now, *args)
    end

    sig { params(delay: T.any(Numeric, ActiveSupport::Duration), args: T.untyped).void }
    def perform_in(delay, *args)
      T.unsafe(self).perform_at(T.unsafe(Time.now) + delay, *args)
    end
  end

  mixes_in_class_methods(ClassMethods)
end
