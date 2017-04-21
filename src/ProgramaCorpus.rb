require 'roo'

files = []
(1..20).each do |i|
    files << File.new("../generatedFiles/corpus" + i.to_s + ".txt", "w")
end

xlsx = Roo::Spreadsheet.open('../inputFiles/stackoverflow.xlsx')

(1..xlsx.sheet(0).last_row).each do |i|
    number = xlsx.sheet(0).row(i)[1]
    files[number - 1].write((xlsx.sheet(0).row(i)[0]).to_s + "\n")
end