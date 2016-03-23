class CrawlingJob
  include Sidekiq::Worker
  sidekiq_options unique: :while_executing

  def perform(id)
    link = LinkSource.find_by(id: id)
    return unless link.present?

    10.times do
      break if crawl!(link)
      sleep(1.0/2.0)
    end
    Article.where(link: link.url).find_each do |article|
      article.update_attributes(title: link.title)
    end
  end

  def crawl!(link)
    data = fetch_data(link)
    return false unless valid_open_graph?(data)
    link.set_crawling_data(data)
    link.save!
  end

  def fetch_data(link)
    OpenGraph.new(link.url, {headers: {'Accept-Language' => 'ko-KR,ko;q=0.8,en-US;q=0.6,en;q=0.4'}})
  end

  def valid_open_graph?(data)
    data.present? and data.title.present? and data.title != data.src
  end
end
