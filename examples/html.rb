require 'rubygems'
require 'bundler/setup'
require File.expand_path('../../lib/coping', __FILE__)

html = Coping::HTML.new(<<-HTML)
  <!doctype html>
  <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
      <title>Coping Test</title>
    </head>
    <body>
      
      <!-- a comment -->
      
      <a href="/visit?[%= params %]">
        Visit [%= params['location'] %]
      </a>
      
    </body>
  </html>
HTML

params = {'location' => '<Earth>', 'p' => '1'}
puts html.result(binding)

