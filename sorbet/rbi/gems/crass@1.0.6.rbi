# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `crass` gem.
# Please instead update this file by running `bin/tapioca gem crass`.


# source://crass//lib/crass/token-scanner.rb#3
module Crass
  class << self
    # source://crass//lib/crass.rb#10
    def parse(input, options = T.unsafe(nil)); end

    # source://crass//lib/crass.rb#18
    def parse_properties(input, options = T.unsafe(nil)); end
  end
end

# source://crass//lib/crass/parser.rb#10
class Crass::Parser
  # source://crass//lib/crass/parser.rb#126
  def initialize(input, options = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#137
  def consume_at_rule(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#184
  def consume_component_value(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#209
  def consume_declaration(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#276
  def consume_declarations(input = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#326
  def consume_function(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#357
  def consume_qualified_rule(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#398
  def consume_rules(flags = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#434
  def consume_simple_block(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#458
  def create_node(type, properties = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#466
  def create_selector(input); end

  # source://crass//lib/crass/parser.rb#474
  def create_style_rule(rule); end

  # source://crass//lib/crass/parser.rb#483
  def parse_component_value(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#510
  def parse_component_values(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#524
  def parse_declaration(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#552
  def parse_declarations(input = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#560
  def parse_properties(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#586
  def parse_rule(input = T.unsafe(nil)); end

  # source://crass//lib/crass/parser.rb#615
  def parse_value(nodes); end

  # source://crass//lib/crass/parser.rb#120
  def tokens; end

  class << self
    # source://crass//lib/crass/parser.rb#25
    def parse_properties(input, options = T.unsafe(nil)); end

    # source://crass//lib/crass/parser.rb#36
    def parse_rules(input, options = T.unsafe(nil)); end

    # source://crass//lib/crass/parser.rb#54
    def parse_stylesheet(input, options = T.unsafe(nil)); end

    # source://crass//lib/crass/parser.rb#74
    def stringify(nodes, options = T.unsafe(nil)); end
  end
end

# source://crass//lib/crass/parser.rb#11
Crass::Parser::BLOCK_END_TOKENS = T.let(T.unsafe(nil), Hash)

# source://crass//lib/crass/scanner.rb#8
class Crass::Scanner
  # source://crass//lib/crass/scanner.rb#25
  def initialize(input); end

  # source://crass//lib/crass/scanner.rb#34
  def consume; end

  # source://crass//lib/crass/scanner.rb#46
  def consume_rest; end

  # source://crass//lib/crass/scanner.rb#11
  def current; end

  # source://crass//lib/crass/scanner.rb#57
  def eos?; end

  # source://crass//lib/crass/scanner.rb#63
  def mark; end

  # source://crass//lib/crass/scanner.rb#69
  def marked; end

  # source://crass//lib/crass/scanner.rb#15
  def marker; end

  # source://crass//lib/crass/scanner.rb#15
  def marker=(_arg0); end

  # source://crass//lib/crass/scanner.rb#80
  def peek(length = T.unsafe(nil)); end

  # source://crass//lib/crass/scanner.rb#19
  def pos; end

  # source://crass//lib/crass/scanner.rb#19
  def pos=(_arg0); end

  # source://crass//lib/crass/scanner.rb#87
  def reconsume; end

  # source://crass//lib/crass/scanner.rb#93
  def reset; end

  # source://crass//lib/crass/scanner.rb#103
  def scan(pattern); end

  # source://crass//lib/crass/scanner.rb#115
  def scan_until(pattern); end

  # source://crass//lib/crass/scanner.rb#22
  def string; end
end

# source://crass//lib/crass/token-scanner.rb#6
class Crass::TokenScanner
  # source://crass//lib/crass/token-scanner.rb#9
  def initialize(tokens); end

  # source://crass//lib/crass/token-scanner.rb#16
  def collect; end

  # source://crass//lib/crass/token-scanner.rb#24
  def consume; end

  # source://crass//lib/crass/token-scanner.rb#7
  def current; end

  # source://crass//lib/crass/token-scanner.rb#32
  def peek; end

  # source://crass//lib/crass/token-scanner.rb#7
  def pos; end

  # source://crass//lib/crass/token-scanner.rb#39
  def reconsume; end

  # source://crass//lib/crass/token-scanner.rb#44
  def reset; end

  # source://crass//lib/crass/token-scanner.rb#7
  def tokens; end
end

# source://crass//lib/crass/tokenizer.rb#9
class Crass::Tokenizer
  # source://crass//lib/crass/tokenizer.rb#62
  def initialize(input, options = T.unsafe(nil)); end

  # source://crass//lib/crass/tokenizer.rb#70
  def consume; end

  # source://crass//lib/crass/tokenizer.rb#275
  def consume_bad_url; end

  # source://crass//lib/crass/tokenizer.rb#301
  def consume_comments; end

  # source://crass//lib/crass/tokenizer.rb#326
  def consume_escaped; end

  # source://crass//lib/crass/tokenizer.rb#350
  def consume_ident; end

  # source://crass//lib/crass/tokenizer.rb#375
  def consume_name; end

  # source://crass//lib/crass/tokenizer.rb#407
  def consume_number; end

  # source://crass//lib/crass/tokenizer.rb#430
  def consume_numeric; end

  # source://crass//lib/crass/tokenizer.rb#469
  def consume_string(ending = T.unsafe(nil)); end

  # source://crass//lib/crass/tokenizer.rb#510
  def consume_unicode_range; end

  # source://crass//lib/crass/tokenizer.rb#542
  def consume_url; end

  # source://crass//lib/crass/tokenizer.rb#590
  def convert_string_to_number(str); end

  # source://crass//lib/crass/tokenizer.rb#616
  def create_token(type, properties = T.unsafe(nil)); end

  # source://crass//lib/crass/tokenizer.rb#627
  def preprocess(input); end

  # source://crass//lib/crass/tokenizer.rb#642
  def start_identifier?(text = T.unsafe(nil)); end

  # source://crass//lib/crass/tokenizer.rb#666
  def start_number?(text = T.unsafe(nil)); end

  # source://crass//lib/crass/tokenizer.rb#685
  def tokenize; end

  # source://crass//lib/crass/tokenizer.rb#702
  def valid_escape?(text = T.unsafe(nil)); end

  class << self
    # source://crass//lib/crass/tokenizer.rb#45
    def tokenize(input, options = T.unsafe(nil)); end
  end
end

# source://crass//lib/crass/tokenizer.rb#10
Crass::Tokenizer::RE_COMMENT_CLOSE = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#11
Crass::Tokenizer::RE_DIGIT = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#12
Crass::Tokenizer::RE_ESCAPE = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#13
Crass::Tokenizer::RE_HEX = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#14
Crass::Tokenizer::RE_NAME = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#15
Crass::Tokenizer::RE_NAME_START = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#16
Crass::Tokenizer::RE_NON_PRINTABLE = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#17
Crass::Tokenizer::RE_NUMBER_DECIMAL = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#18
Crass::Tokenizer::RE_NUMBER_EXPONENT = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#19
Crass::Tokenizer::RE_NUMBER_SIGN = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#21
Crass::Tokenizer::RE_NUMBER_STR = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#33
Crass::Tokenizer::RE_QUOTED_URL_START = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#35
Crass::Tokenizer::RE_UNICODE_RANGE_END = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#34
Crass::Tokenizer::RE_UNICODE_RANGE_START = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#36
Crass::Tokenizer::RE_WHITESPACE = T.let(T.unsafe(nil), Regexp)

# source://crass//lib/crass/tokenizer.rb#37
Crass::Tokenizer::RE_WHITESPACE_ANCHORED = T.let(T.unsafe(nil), Regexp)
