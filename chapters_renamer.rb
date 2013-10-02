# For some manga with chapters like:
#   Chapter 1, Chapter 2, ..., Chapter 10
#
# It will be sorted like this:
#   Chapter 1, Chapter 10, Chapter 2, ...
#
# This file will rename the chapters for them to sort
#   Chapter 1   -> Chapter 001
#   Chapter 10  -> Chapter 010
#   Chapter 100 -> Chapter 100

def rename_chapters(title)
  chapters_path = File.join('public', 'images', title, '*')

  Dir.glob(chapters_path).each do |chapter|
    name = chapter.split(/\/|\\/).last
    num  = name.match(/\d+$/)[0] rescue next

    next if num.size >= 3

    new_num = num.rjust(3, '0')
    new_name = chapter.gsub(/\d+$/, new_num)

    if File.rename(chapter, new_name)
      puts "Renamed #{ chapter } to #{ new_name }"
    else
      puts "Failed to rename #{ chapter } to #{ new_name }"
    end
  end

end

titles_path = File.join('public', 'images', '**')
titles      = Dir.glob(titles_path).map { |item| item.split(/\/|\\/).last }

puts 'Which manga to rename the chapters?'
(1..titles.size).each { |i| puts "#{ i }. #{ titles[i -1] }" }
puts "Or input else to rename all"
print "\nPick your poison: "

pick  = gets.chomp.to_i
manga = titles[pick -1]

if pick == 0 || manga.nil?
  puts 'You pick all'
  titles.each { |t| rename_chapters t }
else
  puts "You pick #{ manga }"
  rename_chapters manga
end
