module DoorkeeperMethods
  extend ActiveSupport::Concern

  ENABLE_LOG = {
    :"doorkeeper/tokens" => [:create, :revoke]
  }

  included do
    after_action do
      ENABLE_LOG.has_key?(controller_path.to_sym) and
        ENABLE_LOG[controller_path.to_sym].include?(action_name.to_sym) and
        dummy_logger "Proccessed the action: #{action_name}"
    end
  end

  def dummy_logger(*)
    # Do someting?
  end
end
