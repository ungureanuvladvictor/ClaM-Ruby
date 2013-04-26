def sim(a,b)
  if a==b
    return 1
  else
    return -1
  end
end

def calc_cheat(a,b)
  if a.length>b.length
    return calc_cheat(b,a)
  end
  @F=Array.new(a.length)
  for i in 0..a.length-1
    @F[i]=Array.new(b.length)
    @F[i][0]=i
  end

  for j in 1..b.length-1
    @F[0][j]=j
  end

  for i in 1..a.length-1
    for j in 1..b.length-1
      @Match = @F[i-1][j-1] + sim(a[i], b[j])
      @Delete = @F[i-1][j] -1
      @Insert = @F[i][j-1] -1
      @F[i][j] = [@Match, @Insert, @Delete].max
    end
  end
  ret = @F[a.length-1][b.length-1]  .to_f / b.length.to_f
  return [ret>0.65,ret]
end


puts calc_cheat('This answer is very similar to the other one','This answer is extremely similar to the other one')
puts calc_cheat('This answer is very similar to the other one','This random answer is almost very similar to the other one')
puts calc_cheat('This random answer is almost randomly the same as almost the other one not','This answer is very similar to the other one')
puts calc_cheat('answer123','answer 123')

