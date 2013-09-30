require 'rubygems'
require 'bundler/setup'

require 'sinatra'


get '/' do
  erb :index, locals: {
                collection: manga_collection.keys
              }
end


get '/:title' do
  title    = params[:title]
  chapters = manga_collection[title].keys

  erb :chapters, locals: {
                   title:    title,
                   chapters: chapters
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
