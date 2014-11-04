class ID3
  attr_reader :set, :i_t, :categories, :result

  def initialize tset, categories
    # 学習集合の平均情報量を計算
    @i_t = info tset

    # 決定木の作成
    @set = tset
    @categories = categories
    @result = exec @set, @categories
  end

  # ID3のアルゴリズムにより決定木を作成します。
  # 学習集合 s
  # 質問カラムのリスト xlist
  def exec s, xlist
    h = idx_hash s, :category
    # カテゴリーが1つになったら
    if h.length == 1
      return [h.keys[0]]
    end
    # 質問が1つだったら
    if xlist.length == 1
      h = idx_hash s, xlist[0]
      ret = [xlist[0], {}]
      h.each_pair do |k, v|
        ret[1][k] = idx_hash(v, :category).keys
      end
      return ret
    end
    g = gain s, xlist
    # 利得の高い質問の部分集合を作る
    ns = idx_hash s, g[0][0]
    ret = [g[0][0], {}]
    # 次の質問リストから既に行った質問を削除する
    xlist.delete g[0][0]
    ns.each_pair do |k, v|
      ret[1][k] = exec v, xlist
    end
    ret
  end

  # 集合 s の cloum の値をキーとする部分集合のハッシュを返します。 
  def idx_hash s, cloum
    rhash = {}
    s.each do |item|
      if rhash.has_key? item[cloum]
        rhash[item[cloum]] << item
      else
        rhash[item[cloum]] = [item]
      end
    end
    rhash
  end

  # 集合 s の平均情報量を返します。
  def info s
    chash = idx_hash s, :category
    i = 0
    #puts "chash=#{chash.length}"
    chash.each_pair do |k, v|
      #puts "#{k} #{v.length} #{s.length}"
      p = v.length.to_f / s.length
      i += -p * Math.log(p) / Math.log(3)
    end
    i
  end

  # 質問カラム x に対する利得のリストを返します。
  # s 対象の集合
  # xlist 質問カラムのリスト
  # 戻り値
  # ex.[[:a2, 0.6126016192893442], [:a3, 0.45548591500359525], [:a1, 0.10785781643217829]]
  def gain s, xlist
    g = {}
    xlist.each do |x|
      h = idx_hash s, x
      ix_t = 0
      h.each_pair do |k, v|
        ix_t += v.length.to_f / s.length * info(v)
      end
      g[x] = @i_t - ix_t
      #puts "#{x}=#{g[x]}"
    end
    g.sort{|a, b| b[1] <=> a[1]}
  end

end
