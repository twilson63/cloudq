if ENV['MONGOHQ_URL']
  MongoMapper.config = {:production => {'uri' => ENV['MONGOHQ_URL']}}
  MongoMapper.connect(:production)
else
  MongoMapper.database = 'cloudq'
end

module Cloudq
  class Job
    include MongoMapper::Document
    before_validation :write_initial_state, :on => :create

    key :queue, String
    key :klass, String
    key :args, Array 
    key :workflow_state, String

    timestamps!

    include Workflow

    workflow do
      state :queued do
        event :reserve, :transitions_to => :reserved
      end
      state :reserved do
        event :delete, :transitions_to => :deleted
      end
      state :deleted
    end

    def load_workflow_state
      self[:workflow_state]
    end

    def persist_workflow_state(new_value)
      self[:workflow_state] = new_value
      save!
    end

    private
      def write_initial_state
        update_attributes(self.class.workflow_column => current_state.to_s) if load_workflow_state.blank?
      end

  end
end
