
CATEGORIES = 20

# Cabecera 1
def numDocs (i, files)
  lines = File.foreach("./../generatedFiles/corpus" + (i+1).to_s + ".txt").count
  files[i].write("Número de documentos(preguntas) del corpus : " + lines.to_s)
end

# Cabecera 2
def numPalabras (i, files)
  words = []
  words_list = File.read("./../generatedFiles/corpus" + (i+1).to_s + ".txt").split(/[^[[:word:]]]/)

  words_list.each_with_index do |value, index|
      if((value.length != 0)) then
          words << String(value.downcase)
      end
  end
  words = words.sort_by(&:downcase)
  files[i].write("\nNúmero de palabras del corpus: " + words.length.to_s)


end

# Palabra:<cadena> Frec:<número entero> LogProb:<número real>
def frecuenciaPalabras(i, files)

  # Creación de arrauy con todas las palabras
  words = []
  words_list = File.read("./../generatedFiles/corpus" + (i+1).to_s + ".txt").split(/[^[[:word:]]]/)

  words_list.each_with_index do |value, index|
      if((value.length != 0)) then
          words << String(value.downcase)
      end
  end

  words = words.sort_by(&:downcase)

  #Guardamos en un array todas las palabras del vocabulario.txt
  palabras_vocabulario = Hash.new 0
  vocabulario = File.read("./../generatedFiles/vocabulario.txt").split(/\n/)
  vocabulario.delete_at(0)

  vocabulario.each do |value|
    palabras_vocabulario[value.match(/Palabra: (.*)/)[1]] = 0
  end

  # Contamos el num de veces que aparece la palabra.s
  words.each do |word|
      palabras_vocabulario[word] += 1
  end


  frec = 0

  palabras_vocabulario.each do |key, word|
      files[i].write("\nPalabra: " + key + " Frec: " + word.to_s)
      frec = frec + word
  end

  puts frec
end



#Main

files = []

(1..CATEGORIES).each do |i|
    files << File.new("./../generatedFiles/aprendizaje" + i.to_s + ".txt", "w+")
end

vocabulario = File.read("./../generatedFiles/vocabulario.txt")

(0..CATEGORIES - 1).each do |i|
  numDocs(i, files)
  numPalabras(i, files)
  frecuenciaPalabras(i, files)

end
