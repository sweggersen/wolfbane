class Medical < ActiveRecord::Base
  belongs_to :sheep
  def timestamp
    datetime.localtime.strftime "%Y %d/%m %X"
  end
end
