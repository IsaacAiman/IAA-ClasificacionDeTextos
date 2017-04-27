require 'roo'

CATEGORIES = 20

files = []
(1..CATEGORIES).each do |i|
    files << File.new("./../generatedFiles/corpus" + i.to_s + ".txt", "w+")
end

fileTodo = File.new("./../generatedFiles/corpusTodo.txt", "w+")

xlsx = Roo::Spreadsheet.open('./../inputFiles/stackoverflow.xlsx')

(1..xlsx.sheet(0).last_row).each do |i|
    number = xlsx.sheet(0).row(i)[1]
    files[number - 1].puts(((xlsx.sheet(0).row(i)[0]).to_s))
end

files.each do |file|
    file.close
end

(1..CATEGORIES).each do |i|
    fileTodo.write(File.read("./../generatedFiles/corpus" + i.to_s + ".txt"))
end

fileTodo.close
