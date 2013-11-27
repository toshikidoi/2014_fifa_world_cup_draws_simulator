POT_1 = ["ブラジル", "アルゼンチン", "コロンビア", "ウルグアイ", "スペイン", "ドイツ", "ベルギー", "スイス"]
POT_2 = ["日本", "オーストラリア", "韓国", "イラン", "アメリカ", "コスタリカ", "ホンジュラス", "メキシコ"]
POT_3 = ["チリ", "エクアドル", "ナイジェリア", "コートジボワール", "カメルーン", "ガーナ", "アルジェリア", "フランス"]
POT_4 = ["オランダ", "イタリア", "ロシア", "ボスニア・ヘルツェゴビナ", "イングランド", "ギリシャ", "クロアチア", "ポルトガル"]
POTS = [POT_1, POT_2, POT_3, POT_4]

AFC = ["日本", "オーストラリア", "韓国", "イラン"]
CAF = ["ナイジェリア", "コートジボワール", "カメルーン", "ガーナ", "アルジェリア"]
CONCACAF = ["アメリカ", "コスタリカ", "ホンジュラス", "メキシコ"]
CONMEBOL = ["ブラジル", "アルゼンチン", "コロンビア", "チリ", "エクアドル", "ウルグアイ"]
UEFA = ["スペイン", "オランダ", "イタリア", "ベルギー", "スイス", "ドイツ", "ロシア", "ボスニア・ヘルツェゴビナ", "イングランド", "ギリシャ", "クロアチア", "ポルトガル", "フランス"]
CONFEDERATIONS = [AFC, CAF, CONCACAF, CONMEBOL, UEFA]

def confederation(country)
  CONFEDERATIONS.each do |c|
    return c[0] if c.include?(country)
  end
end

def countries_of_group(group, tmp_results)
  countries = tmp_results.select{|result| result[:group] == group}[0][:countries]
end

def check_duplication(country, group, tmp_results)
  countries = countries_of_group(group, tmp_results).select{|country| country != ""} << country
  confederations = countries.map{|c| confederation(c)}
  if confederations.uniq.length == confederations.length
    return false
  else
    a = confederations.uniq.select{|i| confederations.index(i) != confederations.rindex(i)}
    if a.length == 1 && a[0] == UEFA[0] && (confederations.length - confederations.uniq.length) < confederations.length - 2
      return false
    end
    return true
  end
end

def decide_group(country, groups, tmp_results)
  begin
    group = groups.sample
  end while check_duplication(country, group, tmp_results)
  group
end

def decide_position(group, tmp_results)
  rest_of_positions = []
  countries_of_group(group, tmp_results).each_with_index do |country, i|
    rest_of_positions << i if country == ""
  end
  rest_of_positions.sample
end

def draw(country, groups, tmp_results)
  group = decide_group(country, groups, tmp_results)
  position = decide_position(group, tmp_results)
  {group: group, position: position}
end

results = []

("A".."H").each_with_index do |group, i|
  results << {group: group, countries: []}
  (0..3).each do |position|
    results[i][:countries] << ""
  end
end

POTS.each_with_index do |pot, i|
  groups = ("A".."H").to_a
  pot.unshift(pot.pop) if i == 2
  pot.each_with_index do |country, j|
    if i == 0 && j == 0
      result = {group: "A", position: 0}
    else
      result = draw(country, groups, results)
      result[:position] = 0 if i == 0
    end
    countries_of_group(result[:group], results)[result[:position].to_i] = country
    groups.delete(result[:group])
  end
end

results.each do |result|
  countries = result[:countries]
  puts "Group #{result[:group]} : #{countries[0]} #{countries[1]} #{countries[2]} #{countries[3]}"
end