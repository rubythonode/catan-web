class Link < ActiveRecord::Base
  extend Enumerize

  validates :url, uniqueness: {case_sensitive: false}
  enumerize :crawling_status, in: [:not_yet, :completed], predicates: true, scope: true

  ## uploaders
  # mount
  mount_uploader :image, ImageUploader

  def crawl_async
    if crawling_status.not_yet?
      CrawlingJob.perform_async(self.id)
      self.reload
    end
  end

  def crawl!
    data = OpenGraph.new(self.url, {headers: {'Accept-Language' => 'ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4'}})
    return false unless valid_open_graph?(data)
    self.metadata = data.metadata.to_json || self.metadata
    self.title = data.title || self.title
    self.remote_image_url = (data.images[0] if data.images.any?) || self.image
    self.page_type = data.type || self.page_type
    self.body = data.description || self.body
    self.crawling_status = :completed
    self.crawled_at = DateTime.now
    self.save!
  end

  def valid_open_graph?(data)
    data.present? and data.title.present? and data.title != data.src
  end
end
