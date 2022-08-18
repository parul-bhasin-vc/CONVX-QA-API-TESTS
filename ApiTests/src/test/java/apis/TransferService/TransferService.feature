@Smoke1
Feature: POST 

  Background:
    
    * def functions = karate.read('../../common.js')()
    * def env = functions.readEnv()
    * def urlConfig = read('../../api-config.json')['qa-US']
    
    
    
    * def transferServiceBaseApiURL = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].endpoint")
    * def transferServiceBaseApiHDR = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].header")[0][0]
    Given url transferServiceBaseApiURL+"addCarToCart"
    And headers transferServiceBaseApiHDR
       
    
    And def user = read('TransferServiceInput.json')
    
   
  Scenario: create a sample Post

 
    And request user
    When method post
    Then status 200
    * print response
    
       * def cartId = response.data.cartId
       * print cartId