require 'rubygems'
require 'bundler/setup'

require 'sinatra'

get '/' do
  erb :index, locals: {
                manga: manga_collection
              }
end


def manga_collection
  path       = File.join('manga', '**', '*.jpg')
  collection = {}

  Dir.glob(path).each do |item|
    title, chapter, img = item.split(/\/|\\/)[1..3]

    return if img.nil?

    collection[title]          ||= {}
    collection[title][chapter] ||= []

    collection[title][chapter].push(img)
  end

  collection
end
