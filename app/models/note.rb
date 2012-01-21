require 'redcarpet'

class Note < ActiveRecord::Base
  acts_as_taggable
  has_paper_trail

  before_save :extract_tags

  def extract_tags
    tags = Set.new
    body.scan(/[^\w#]#(\w+)\b/) do |tag|
      tags << tag
    end
    self.tag_list = tags.sort.join(', ')
  end

  def rendered_body
    markdown = Redcarpet::Markdown.new(RenderWithTags)
    markdown.render(body)
  end
end
