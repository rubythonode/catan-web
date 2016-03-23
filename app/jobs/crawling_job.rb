class CrawlingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(id)
    source = LinkSource.find_by(id: id)
    return unless source.present?

    10.times do
      break if source.crawl!
      sleep(1.0/2.0)
    end
    Article.where(link: source.url).find_each do |article|
      article.update_attributes(title: source.title)
    end

  end
end
