class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :contributions, :through => :user

  validates_presence_of :name, :on => :create, :message => "can't be blank"
  #default_scope order("LOWER(name) ASC")  

  scope :sort_by, lambda { |operand|
    query = select('profiles.*, profile_contributions.count AS contributions_count')
              .joins(:user)
              .joins("LEFT JOIN (SELECT COUNT(*) AS count, user_id FROM contributions GROUP BY user_id) AS profile_contributions ON users.id = profile_contributions.user_id")

    operand = 'name' if operand.nil?

    if operand == 'name'
      @query = query.order('LOWER(profiles.name)')
    else
      @query = query.order('profile_contributions.count DESC, LOWER(profiles.name) ASC')
    end

    sort_by_contributions_since(operand)
  }


  def self.sort_by_contributions_since(start_time)
    @query
  end
end
