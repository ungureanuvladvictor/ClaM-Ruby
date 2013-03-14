class Error
  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def log(message)
    File.open(@path,'a') {
        |f|
      t = Time.now()
      f.write(t.year.to_s + "-" + t.month.to_s + "-" + t.day.to_s + " " + t.hour.to_s + ":" + t.min.to_s + ":" + t.sec.to_s )
      f.write(" "+message+"\n")
    }
  end
  end