# encoding: utf-8
################################################################################
# @file      best_plan_spec.rb
# @author    Vishal Srivastava <http://vishalthearch.branded.me>
# @brief     Test case for best_plan.rb
# @Keywords  best plan, pricing
# @Std       RSpec 3.3.2
##------------------------------------------------------------------------------

require_relative '../best_plan'

RSpec.describe BestPlan do
  before(:context) do
    p "Test Case Convention: Test#N (+/-): where N is test case number, +=positive case, -=negative case"
  end
  describe "#all_plans P1...P8" do
    context "Test#0 (+): total 8 plans" do
      it "return total of 8 plans" do
        best_plan = BestPlan.new([])
        expect(best_plan.all_plans.size).to eq(8)
      end
    end
  end
  describe "#selected_features" do
    context "Test#1 (-): no feature selected" do
      it "Input=[] Output=No matching plan for your features" do
        selected_features = []
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("No matching plan for your features")
      end
    end
    context "Test#2 (-): feature does not exist" do
      it "Input=['F'] Output=No matching plan for your features" do
        selected_features = ['F']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("No matching plan for your features")
      end
    end
    context "Test#3 (+): one plan return" do
      it "Input=['F1','F2'] Output=Best Plan: P1 for $2.00" do
        selected_features = ['F1','F2']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P1 for $2.00")
      end
    end
    context "Test#4 (+): one plan return - order does not matter" do
      it "Input=['F1','F3'] Output=Best Plan: P6 for $2.00" do
        selected_features = ['F1','F3']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P6 for $2.00")
      end
    end
    context "Test#5 (+): two plan return (should not select P2)" do
      it "Input=['F1','F2','F3'] Output=Best Plan: P1 P6 for $4.00" do
        selected_features = ['F1','F2','F3']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P1 P6 for $4.00")
      end
    end
    context "Test#6 (+): one plan return with more features (should not select P4)" do
      it "Input=['F1','F2','F3','F4','F5'] Output=Best Plan: P5 for $12.50" do
        selected_features = ['F1','F2','F3','F4','F5']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P5 for $12.50")
      end
    end
    context "Test#7 (+): three plan return" do
      it "Input=['F3','F4','F5'] Output=Best Plan: P6 P7 P8 for $12.00" do
        selected_features = ['F3','F4','F5']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P6 P7 P8 for $12.00")
      end
    end
    context "Test#8 (-): one plan return (1 feature exist, 1 feature does not)" do
      it "Input=['F1','F'] Output=No matching plan for your features" do
        selected_features = ['F1','F100']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("No matching plan for your features")
      end
    end
    context "Test#9 (+): one plan return" do
      it "Input=['F1'] Output=Best Plan: P1 for $2.00" do
        selected_features = ['F1']
        best_plan = BestPlan.new(selected_features)
        expect(best_plan.to_s).to eq("Best Plan: P1 for $2.00")
      end
    end
  end
end