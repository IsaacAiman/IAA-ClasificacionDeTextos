file = File.new("./../generatedFiles/vocabulario.txt", "w+")

words = []
words_list = File.read("./../generatedFiles/corpusTodo.txt").split(/[^[[:word:]]]/)

words_list.each_with_index do |value, index|
    if((value.length != 0) && (!words.include? value.downcase)) then
        words << String(value.downcase)
    end
end

words = words.sort_by(&:downcase)
puts words
file.write("Número de palabras: " + words.length.to_s + "\n")

words.each do |value|
   file.write("Palabra: " + value + "\n")
end
