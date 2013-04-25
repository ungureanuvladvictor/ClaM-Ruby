def calc_cheat(a,b)
  wordsa = a.downcase.split(/\.?\s+/)
  wordsb = b.downcase.split(/\.?\s+/)
  if wordsa.count>wordsb.count
    return calc_cheat(b,a)
  end
  counta=0
  countb=0
  wordsa.each do |i|
    if wordsb.include?(i)
      counta = counta+1
    end
  end
  wordsb.each do |i|
    if wordsa.include?(i)
      countb = countb+1
    end
  end
  ret = counta.to_f/wordsa.count.to_f
  if wordsa.count<=5
    return [ret>0.5,ret]
  elsif wordsa.count<=10
    return [ret>0.75,ret]
  end
  return [ret>0.5,ret]
end

#puts calc_cheat('This answer is very similar to the other one','This answer is extremely similar to the other one')
#puts calc_cheat('This answer is very similar to the other one','This random answer is almost randomly the same as almost the other one not')
#puts calc_cheat('This random answer is almost randomly the same as almost the other one not','This answer is very similar to the other one')

