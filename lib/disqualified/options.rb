# typed: strict

class Disqualified::Options
  extend T::Sig

  Scalar = T.type_alias { T.any(Integer, String, T::Boolean) }
  FlatHash = T.type_alias { T::Hash[String, Scalar] }
  Value = T.type_alias { T.nilable(T.any(Scalar, FlatHash)) }

  sig { void }
  def initialize
    @data = T.let({}, T::Hash[String, Value])
  end

  sig { params(key: String).returns(Value) }
  def [](key)
    @data[key]
  end

  sig { params(key: String, value: Value).returns(Value) }
  def []=(key, value)
    @data[key] = value
  end

  sig { params(key: String).returns(T::Boolean) }
  def key?(key)
    @data.key?(key)
  end

  sig { returns(T::Hash[String, Value]) }
  private def to_h
    @data
  end
end
