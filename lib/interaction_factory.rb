require 'join_flow'
require 'visit_flow'

class InteractionFactory
  def self.create(flow_type)
    case flow_type
    when 'Join'
      JoinFlow.new
    when 'Visit'
      VisitFlow.new
    end
  end
end
