module WithMoneyColumn
  extend ActiveSupport::Concern

  DEFAULT_MONEY_COLUMN_OPTIONS = {
    allow_nil: true,
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 21_474_836
    },
    with_model_currency: :currency
  }.freeze

end


