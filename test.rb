require File.dirname(__FILE__) + "/id3"
require 'pp'

# 学習集合
list = [
  {:name => :penguin,   :a1 => :carnivore, :a2 => :egg,        :a3 => :warm_blooded, :category => :birds    },
  {:name => :lion,      :a1 => :carnivore, :a2 => :viviparous, :a3 => :warm_blooded, :category => :mammalia },
  {:name => :cow,       :a1 => :herbivory, :a2 => :viviparous, :a3 => :warm_blooded, :category => :mammalia },
  {:name => :lizard,    :a1 => :carnivore, :a2 => :egg,        :a3 => :cold_blooded, :category => :reptilian},
  {:name => :paddybird, :a1 => :herbivory, :a2 => :egg,        :a3 => :warm_blooded, :category => :birds    }
]

categories = [:a1, :a2, :a3]

dt = ID3.new list, categories

pp dt.result
