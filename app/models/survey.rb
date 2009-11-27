class Survey
  
  include CouchPotato::Persistence
  include Symlog
  
  property :described_person
  
  # Person descriptions
  Description.names.each do |name|
    property name
  end
  
  view :all, :key => :created_at
  
  POSSIBLE_RATINGS = {
    :nie      => 0,
    :selten   => 1,
    :manchmal => 2,
    :haeufig  => 3,
    :immer    => 4
  }
  
  def self.find_all
    CouchPotato.database.view all
  end
  
  def self.count
    find_all.size
  end
  
  def save
    CouchPotato.database.save_document self
  end
  
  def self.find(id)
    CouchPotato.database.load_document id.to_s
  end
  
  def descriptions
    @descriptions ||= Description.create_all_from_survey(self)
  end
  
  def dimensions
    @dimension_values ||= DIMENSIONS.collect do |name, directions|
      Dimension.new(name, directions, self.send("#{name}_value"))
    end
  end
  
end
