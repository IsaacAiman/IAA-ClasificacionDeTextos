#!/usr/bin/env ruby

CATEGORIES = 20


# En corpus está el corpus indicado.
ARGV.each do|filename|
  $corpus = File.read(filename).split(/\n/)
end

# Abrimos todos los ficheros de aprendizaje

# Abrimos el fichero vocabulario.txt
$vocabulario = File.read("./../generatedFiles/vocabulario.txt").split(/\n/)


probabilidades = []

# Pasa un corpus a hash
def probabilidad_palabra(num_fichero, palabra, num_palabras_vocabulario, num_palabras_corpus)

  $files[num_fichero].each do |line|
    key = line.match(/Palabra: (.*) Frec/)[1]
    value = line.match(/LogProb: (.*)/)[1]

    if (key == palabra)
      return value.to_f
    end
  end

  return Math::log(( 1.0 / ( num_palabras_corpus.to_f + num_palabras_vocabulario.to_f + 1).to_f), 2)

end

# Devuelve la categoria a la que pertenece
def calcular_probabilidad(line, num_fichero)

  num_palabras_vocabulario = $vocabulario[0].match(/palabras: (.*)/)[1]
  $files[num_fichero].delete_at(0)
  num_palabras_corpus = $files[num_fichero][0].match(/Número de palabras del corpus: (.*)/)[1]
  $files[num_fichero].delete_at(0)

  probabilidad = 0
  line.split(/[^[[:word:]]]/).reject(&:empty?).each do |word|
    probabilidad += probabilidad_palabra(num_fichero, word, num_palabras_vocabulario, num_palabras_corpus)
  end

  return probabilidad
end


$corpus.each do |line|
  $files = []
  (1..CATEGORIES).each do |i|
      $files << File.read("./../generatedFiles/aprendizaje" + i.to_s + ".txt").split(/\n/)
  end

  mayor = []
  (0..CATEGORIES - 1).each do |num_fichero|
    mayor << calcular_probabilidad(line, num_fichero).to_s
  end

  puts line + " " + mayor.each_with_index.max[1].to_s
end
