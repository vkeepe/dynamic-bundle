# encoding: utf-8
################################################################################
# @file      best_plan.rb
# @author    Vishal Srivastava <http://vishalthearch.branded.me>
# @brief     Find the best plan based on selected items
# @Keywords  best plan, pricing
# @Std       Ruby 2.0.0
##------------------------------------------------------------------------------

require 'json'

# Class finds the combination of plans that offers all 
# selected features at the lowest price. Note that in some cases, 
# it will be just one plan, but in other cases you will need 2+ plans 
# to get all the features you want.
# 
# Goal: find combinations of 1-N plans that fulfill selected 
# features -> select the cheapest combination(s)
class BestPlan
  attr_reader :plans

  def initialize(selected_features)
    plans = self.all_plans
    matching_combinations(plans, selected_features).each do |plans|
      plans = [plans] if plans.is_a?(Hash)
      self.optimal_plan = plans if cheaper?(plans)
    end
  end

  # Returns all the plan in the system.
  # @dependency ./data/bundle.json
  # TODO (Vishal) - Cache it or Move externally to Memcache based on need & size
  def all_plans
    file = File.read('./data/bundle.json')
    plan_hash = JSON.parse(file)
    plans = plan_hash['plans']
  end
 
  # Prints the best plan for the selected features. 
  # Shows the total price of the plan selected.
  def to_s
    if match?
      "Best Plan: " + @plans_name + "for $" + '%.2f' % [(@cost * 100).round / 100.0]
    else
      "No matching plan for your features"
    end
  end

  # all methods that follow will be made private: not accessible for outside objects
  private 
  
  # is there at least one matching plan(s) for requested features
  def match?
    @plans and @plans.size > 0
  end

  # returns an array of all combinations of plans where the selected feature exist
  # Example F1 selected feature existing in following plans
  # [[P1],[P1,P2]...]
  def matching_combinations(plans, selected_features)
    a = {}
    
    # array of plan indexed by feature
    # Example F1 => [P1, P2], F2 => [P2, P3] ...
    plans.each do |plan|
      plan['features'].each do |f|
        a[f] ||= []
        a[f] << plan
      end
    end
    
    # Returns an array of all combinations of elements from all arrays.
    # [P1,P2].product([P3,P4])       #=> [[P1,P3],[P1,P4],[P2,P3],[P2,P4]]
    # @ref http://ruby-doc.org/core-1.9.3/Array.html#method-i-product
    combinations = selected_features.drop(1).inject(a[selected_features[0]]) do |result, element| 
      result.product(a[element] || [])
    end || []
    
    # Get the unique plans as 2 different features can belong to same plan
    combinations.each do |plans|
      plans = [plans] if plans.is_a?(Hash)
      plans.flatten!
      plans.uniq!
    end
  end
  
  # set lowest plan and compute global name/feature_count/cost
  def optimal_plan=(plans)
    @plans = plans
    @cost = 0.00
    @plans_name = ""
    @features_count = 0
    @plans.each do |plan|
      @cost += plan['cost']
      @plans_name += plan['name'] + " "
      @features_count += plan['features'].size
    end
  end

  # Is the matching plan cheaper?
  # We make two assumptions here:
  #   1. If cost are equal, return the plan with more features as cheaper plan
  #   2. If cost are equal, feature count is same and feature belongs to both plan, 
  #      the first plan retrieved is selected. This behavior can be easily changed. 
  #      Based on business need both plan can be shown to user or A/B test can be 
  #      performed on the plan
  def cheaper?(plan)
    cost = plan.inject(0) {|sum,plan| sum + plan['cost']}
    features_count = plan.inject(0) {|sum,plan| sum + plan['features'].size}
    @cost.nil? or cost < @cost or (cost == @cost && features_count > @features_count)
  end
end
