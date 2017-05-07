#!/usr/bin/env ruby

CATEGORIES = 20


# En corpus está el corpus indicado.
ARGV.each do|filename|
  $corpus = File.read(filename).split(/\n/)
end

# Abrimos todos los ficheros de aprendizaje
$files = []
(1..CATEGORIES).each do |i|
    $files << File.read("./../generatedFiles/aprendizaje" + i.to_s + ".txt").split(/\n/)
end

# Abrimos el fichero vocabulario.txt
$vocabulario = File.read("./../generatedFiles/vocabulario.txt").split(/\n/)

# Calculamos el número de palabras del vocabulario.
$num_palabras_vocabulario = $vocabulario[0].match(/palabras: (.*)/)[1]

# Array con todas las tablas hash (una tabla hash por fichero de aprendizaje)
$tablas_hash = []
# Pasa todos los ficheros de aprendizaje a una tabla hash
def to_hash()
  (1..CATEGORIES).each do |i|
    file =  File.read("./../generatedFiles/aprendizaje" + i.to_s + ".txt").split(/\n/)
    hash = {}
    file.each do |line|
      if ((line =~ /Palabra/) != nil)
        key = line.match(/Palabra: (.*) Frec/)[1]
        value = line.match(/LogProb: (.*)/)[1]
      end
      hash[key] = value
    end
    $tablas_hash << hash
  end
end

# Calcula la probabilidad de una palabra usando un fichero de aprendizaje determinado.
def probabilidad_palabra(num_fichero, palabra, num_palabras_corpus)

  if ($tablas_hash[num_fichero][palabra] != nil)
    return $tablas_hash[num_fichero][palabra].to_f
  end
  return Math::log(( 1.0 / ( num_palabras_corpus.to_f + $num_palabras_vocabulario.to_f + 1).to_f), 2)

end

# Devuelve la categoria a la que pertenece
def calcular_probabilidad(line, num_fichero)

  num_palabras_corpus = $files[num_fichero][1].match(/Número de palabras del corpus: (.*)/)[1]

  probabilidad = 0.0
  line.split(/[^[[:word:]]]/).reject(&:empty?).each do |word|
    probabilidad += probabilidad_palabra(num_fichero, word, num_palabras_corpus)
  end

  return probabilidad
end


to_hash()

$corpus.each do |line|
  mayor = calcular_probabilidad(line, 0).to_f
  pos = 0
  (1..CATEGORIES - 1).each do |num_fichero|
    prob = calcular_probabilidad(line, num_fichero).to_f

    if (prob > mayor)
      mayor = prob
      pos = num_fichero
    end

  end
  puts line + " " + (pos + 1).to_s
end

