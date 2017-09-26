module MyFifa
  class ContractTerm < Base
    self.table_name = 'my_fifa_contract_terms'
    
    belongs_to :contract

    ############################
    #  INITIALIZATION METHODS  #
    ############################


    ########################
    #  VALIDATION METHODS  #
    ########################
    
    
  end
end