require 'delegate'
require 'singleton'
require 'tempfile'
require 'fileutils'
require 'stringio'
require 'zlib'
require './decompiling/zip/dos_time'
require './decompiling/zip/ioextras'
require 'rbconfig'
require './decompiling/zip/entry'
require './decompiling/zip/extra_field'
require './decompiling/zip/entry_set'
require './decompiling/zip/central_directory'
require './decompiling/zip/file'
require './decompiling/zip/input_stream'
require './decompiling/zip/output_stream'
require './decompiling/zip/decompressor'
require './decompiling/zip/compressor'
require './decompiling/zip/null_decompressor'
require './decompiling/zip/null_compressor'
require './decompiling/zip/null_input_stream'
require './decompiling/zip/pass_thru_compressor'
require './decompiling/zip/pass_thru_decompressor'
require './decompiling/zip/inflater'
require './decompiling/zip/deflater'
require './decompiling/zip/streamable_stream'
require './decompiling/zip/streamable_directory'
require './decompiling/zip/constants'
require './decompiling/zip/errors'
if defined? JRUBY_VERSION
  require 'jruby'
  JRuby.objectspace = true
end

module Zip
  extend self
  attr_accessor :unicode_names, :on_exists_proc, :continue_on_exists_proc, :sort_entries

  def reset!
    @_ran_once = false
    @unicode_names = false
    @on_exists_proc = false
    @continue_on_exists_proc = false
    @sort_entries = false
  end

  def setup
    yield self unless @_ran_once
    @_ran_once = true
  end

  reset!
end

# Copyright (C) 2002, 2003 Thomas Sondergaard
# rubyzip is free software; you can redistribute it and/or
# modify it under the terms of the ruby license.
