# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `marcel` gem.
# Please instead update this file by running `bin/tapioca gem marcel`.


# source://marcel//lib/marcel.rb#3
module Marcel; end

# source://marcel//lib/marcel/tables.rb#9
Marcel::EXTENSIONS = T.let(T.unsafe(nil), Hash)

# source://marcel//lib/marcel/tables.rb#2394
Marcel::MAGIC = T.let(T.unsafe(nil), Array)

# source://marcel//lib/marcel/magic.rb#12
class Marcel::Magic
  # source://marcel//lib/marcel/magic.rb#16
  def initialize(type); end

  # source://marcel//lib/marcel/magic.rb#103
  def ==(other); end

  # source://marcel//lib/marcel/magic.rb#54
  def audio?; end

  # source://marcel//lib/marcel/magic.rb#58
  def child_of?(parent); end

  # source://marcel//lib/marcel/magic.rb#68
  def comment; end

  # source://marcel//lib/marcel/magic.rb#103
  def eql?(other); end

  # source://marcel//lib/marcel/magic.rb#63
  def extensions; end

  # source://marcel//lib/marcel/magic.rb#107
  def hash; end

  # source://marcel//lib/marcel/magic.rb#53
  def image?; end

  # source://marcel//lib/marcel/magic.rb#13
  def mediatype; end

  # source://marcel//lib/marcel/magic.rb#13
  def subtype; end

  # source://marcel//lib/marcel/magic.rb#50
  def text?; end

  # source://marcel//lib/marcel/magic.rb#98
  def to_s; end

  # source://marcel//lib/marcel/magic.rb#13
  def type; end

  # source://marcel//lib/marcel/magic.rb#55
  def video?; end

  class << self
    # source://marcel//lib/marcel/magic.rb#30
    def add(type, options); end

    # source://marcel//lib/marcel/magic.rb#93
    def all_by_magic(io); end

    # source://marcel//lib/marcel/magic.rb#73
    def by_extension(ext); end

    # source://marcel//lib/marcel/magic.rb#86
    def by_magic(io); end

    # source://marcel//lib/marcel/magic.rb#80
    def by_path(path); end

    # source://marcel//lib/marcel/magic.rb#113
    def child?(child, parent); end

    # source://marcel//lib/marcel/magic.rb#42
    def remove(type); end

    private

    # source://marcel//lib/marcel/magic.rb#117
    def magic_match(io, method); end

    # source://marcel//lib/marcel/magic.rb#127
    def magic_match_io(io, matches, buffer); end
  end
end

# source://marcel//lib/marcel/mime_type.rb#4
class Marcel::MimeType
  class << self
    # source://marcel//lib/marcel/mime_type.rb#8
    def extend(type, extensions: T.unsafe(nil), parents: T.unsafe(nil), magic: T.unsafe(nil)); end

    # source://marcel//lib/marcel/mime_type.rb#29
    def for(pathname_or_io = T.unsafe(nil), name: T.unsafe(nil), extension: T.unsafe(nil), declared_type: T.unsafe(nil)); end

    private

    # source://marcel//lib/marcel/mime_type.rb#36
    def for_data(pathname_or_io); end

    # source://marcel//lib/marcel/mime_type.rb#62
    def for_declared_type(declared_type); end

    # source://marcel//lib/marcel/mime_type.rb#54
    def for_extension(extension); end

    # source://marcel//lib/marcel/mime_type.rb#46
    def for_name(name); end

    # source://marcel//lib/marcel/mime_type.rb#89
    def most_specific_type(*candidates); end

    # source://marcel//lib/marcel/mime_type.rb#79
    def parse_media_type(content_type); end

    # source://marcel//lib/marcel/mime_type.rb#71
    def with_io(pathname_or_io, &block); end
  end
end

# source://marcel//lib/marcel/mime_type.rb#5
Marcel::MimeType::BINARY = T.let(T.unsafe(nil), String)

# source://marcel//lib/marcel/tables.rb#1260
Marcel::TYPE_EXTS = T.let(T.unsafe(nil), Hash)

# source://marcel//lib/marcel/tables.rb#2151
Marcel::TYPE_PARENTS = T.let(T.unsafe(nil), Hash)

# source://marcel//lib/marcel/version.rb#4
Marcel::VERSION = T.let(T.unsafe(nil), String)