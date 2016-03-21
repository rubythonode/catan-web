class CrawlingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(id)
    link = Link.find_by(id: id)
    return unless link.present?

    10.times do
      break if link.crawl!
      sleep(1.0/2.0)
    end
    Article.where(link: link.url).find_each do |article|
      article.update_attributes(title: link.title)
    end

  end
end
