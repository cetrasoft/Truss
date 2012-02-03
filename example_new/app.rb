require 'sinatra'
require 'kss'

get '/' do
  erb :index
end

get '/media' do
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :styleguide
end

get '/font' do
  @sizes = [['1.1.1', 'f-xxs'], ['1.1.2', 'f-xs'], ['1.1.3', 'f-s'], ['1.1.4', 'f-m'], ['1.1.5', 'f-l'], ['1.1.6', 'f-xl'], ['1.1.7', 'f-xxl']]
  @styleguide = Kss::Parser.new('public/stylesheets')
  erb :font
end

helpers do
  # Generates a styleguide block. A little bit evil with @_out_buf, but
  # if you're using something like Rails, you can write a much cleaner helper
  # very easily.
  def styleguide_block(section, &block)
    @section = @styleguide.section(section)
    @test = block.inspect
    @example_html = capture{ block.call }
    @_out_buf << erb(:_styleguide_block)
  end

  # Captures the result of a block within an erb template without spitting it
  # to the output buffer.
  def capture(&block)
    out, @_out_buf = @_out_buf, ""
    yield
    @_out_buf
  ensure
    @_out_buf = out
  end
end