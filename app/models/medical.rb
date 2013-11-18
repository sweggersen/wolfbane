# Medical class, inherits ActiveRecord::Base which handles the database interaction.
class Medical < ActiveRecord::Base
  # Sets up a many-to-one relation to Sheep
  belongs_to :sheep
  # Convenience method for printing a timestamp depending on locale
  def timestamp
    datetime.localtime.strftime "%Y %d/%m %X"
  end
end
