require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'sinatra/static_assets'


get '/' do
  erb :index, locals: {
                collection: Manga.new.titles
              }
end


get '/:title' do |title|
  manga = Manga.new(title)

  erb :chapters, locals: {
                   title:    title,
                   chapters: manga.chapters
                 }
end


#get '/:title/:chapter'
get %r{^/([^images][\w%20]+)/([\w%20]+)$} do |title, chapter|
  redirect to("/#{ URI.escape(title) }/#{ URI.escape(chapter) }/1")
end


get '/*/*/*' do |title, chapter, page|
  manga = Manga.new(title, chapter, page)

  erb :page, locals: {
                title:    title,
                chapter:  chapter,
                page:     page,
                image:    manga.current_image,
                next_img: manga.next_image_link,
                prev_img: manga.prev_image_link,
                total_pages: manga.current_chapter_total
              }
end


class Manga

  def initialize(title = nil, chapter = nil, page = 1)
    fetch_collection

    @title   = title
    @chapter = chapter
    @page    = page.to_i - 1
  end


  def titles
    @collection.keys
  end

  def chapters
    @collection[@title].keys
  end

  def current_image
    chapter_images(@chapter)[@page]
  end

  def current_chapter_total
    chapter_images(@chapter).size
  end

  def next_image_link
    if @page < (chapter_images.size - 1)
      return "/#{ @title }/#{ @chapter }/#{ @page + 2 }"
    end

    chapter_index = chapters.index(@chapter)

    if chapter_index < (chapters.size - 1)
      return "/#{ @title }/#{ chapters[chapter_index + 1] }/1"
    end

    "/#{ @title }"
  end

  def prev_image_link
    if @page != 0
      return "/#{ @title }/#{ @chapter }/#{ @page }"
    end

    chapter_index = chapters.index(@chapter)

    if chapter_index != 0
      prev_chapter = chapters[chapter_index - 1]
      prev_page    = chapter_images(prev_chapter).size
      return "/#{ @title }/#{ prev_chapter }/#{ prev_page }"
    end

    "/#{ @title }"
  end

  private


  def chapter_images(chapter = @chapter)
    @collection[@title][chapter]
  end

  def fetch_collection
    path       = File.join('public', 'images', '*', '*', '*.jpg')
    collection = {}

    Dir.glob(path).each do |item|
      title, chapter, img = item.split(/\/|\\/)[2..4]

      next if img.nil?

      collection[title]          ||= {}
      collection[title][chapter] ||= []

      item.slice! 'public/'
      collection[title][chapter].push(item)
    end

    @collection = collection
  end

end
