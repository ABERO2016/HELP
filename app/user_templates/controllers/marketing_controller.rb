module UserTemplates
  class MarketingController < Volt::ModelController
    def index

    end
    def submit_mktgQ
        flash._notices << 'Thank you for your feedback!'
        mktg = user._mktg
      
    end
  end
end
