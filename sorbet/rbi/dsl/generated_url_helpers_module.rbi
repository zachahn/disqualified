# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for dynamic methods in `GeneratedUrlHelpersModule`.
# Please instead update this file by running `bin/tapioca dsl GeneratedUrlHelpersModule`.

module GeneratedUrlHelpersModule
  include ::ActionDispatch::Routing::UrlFor
  include ::ActionDispatch::Routing::PolymorphicRoutes

  sig { params(args: T.untyped).returns(String) }
  def rails_info_properties_url(*args); end

  sig { params(args: T.untyped).returns(String) }
  def rails_info_routes_url(*args); end

  sig { params(args: T.untyped).returns(String) }
  def rails_info_url(*args); end
end
