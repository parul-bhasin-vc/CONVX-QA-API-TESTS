@Smoke1 @Regression
Feature: Test TransferService API 

  Background:
    
    * def functions = karate.read('../../common.js')()
    * def env = functions.readEnv()
    * def urlConfig = read('../../api-config.json')[env]
    
    
    
 Scenario Outline: Validate  Transfer service 
    
    * def transferServiceBaseApiURL = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].endpoint")
    * def transferServiceBaseApiHDR = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].header")[0][0]
    Given url transferServiceBaseApiURL+"addCarToCart"
    And headers transferServiceBaseApiHDR
       
    
    And def Request = read('../../testData/'+ '<InputJson>')
    And set Request.userinput.contractType = '<contractType>'
    
    And set Request.userinput.input[0].value = '<contractLength>'
    And request Request
    When method POST
    Then status 200    
    
    



    Then match response.data.checkoutUrl contains 'orderId'
    
    * print response
    
       * def cartId = response.data.cartId
       * print cartId
          

    
        Examples:
    | contractType | contractLength  | InputJson								 |
    |     sub      |      24         | TransferServiceInput.json |
    |  sub_fixed   |      48         | carConfigNL.json					 |
    |    cash      |                 | carConfigNL.json					 |
    