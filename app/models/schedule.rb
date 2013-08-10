class Schedule < ActiveRecord::Base
  include Identifiable
  include Eventable

  include ::NewRelic::Agent::MethodTracer

  acts_as_tenant # belongs_to :account
  
  has_many :policy_rules, as: :assignment
  has_many :policies, through: :policy_rules
  has_many :schedule_layers, -> { order(:position) }, dependent: :destroy
  alias_method :layers, :schedule_layers
  has_many :user_schedule_layers, through: :schedule_layers
  has_many :users, through: :user_schedule_layers

  validates :name, :time_zone, 
    presence: true

  accepts_nested_attributes_for :schedule_layers, allow_destroy: true

  def current_user_on_call
    user_schedules = self.class.trace_execution_scoped(['Schedule#current_user_on_call/get_user_schedules']) do
      schedule_layers.first.user_schedules
    end

    self.class.trace_execution_scoped(['Schedule#current_user_on_call/find_current_user']) do
      user_schedules.find do |user_schedule| 
        user_schedule.occurring_at?(Time.zone.now)
      end.try(:user)
    end
  end

  add_method_tracer :current_user_on_call, 'Schedule#current_user_on_call'

end
