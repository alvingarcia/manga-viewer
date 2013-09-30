require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/static_assets'
require 'pry'

get '/' do
  erb :index, locals: {
                collection: manga_collection.keys
              }
end


get '/:title' do |title|
  chapters = manga_collection[title].keys

  erb :chapters, locals: {
                   title:    title,
                   chapters: chapters
                 }
end


#get '/:title/:chapter'
get %r{^/([^images][\w%20]+)/([\w%20]+)$} do |title, chapter|
  redirect to("/#{ URI.escape(title) }/#{ URI.escape(chapter) }/1")
end


get '/*/*/*' do |title, chapter, page|
  image = manga_collection[title][chapter][page.to_i - 1]

  erb :image, locals: {
                title:   title,
                chapter: chapter,
                page:    page,
                image:   image
              }
end


def manga_collection
  path       = File.join('public', 'images', '**', '**', '*.jpg')
  collection = {}

  Dir.glob(path).each do |item|
    title, chapter, img = item.split(/\/|\\/)[2..4]

    next if img.nil?

    collection[title]          ||= {}
    collection[title][chapter] ||= []

    item.slice! 'public/'
    collection[title][chapter].push(item)
  end

  collection
end
