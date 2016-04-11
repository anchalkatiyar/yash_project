class Picture < ActiveRecord::Base
  belongs_to :album
  belongs_to :user
  attr_accessible :caption, :description, :asset

  has_attached_file :asset, styles: {
    large: "800x800>", medium: "300x200>", small: "260x180>", thumb: "80x80#"
  }
do_not_validate_attachment_file_type :asset
  def to_s
    caption? ? caption : "Picture"
  end
end
