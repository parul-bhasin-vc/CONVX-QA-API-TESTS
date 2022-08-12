
Feature: POST 

  Background:
    * url 'https://cdls.uswest2.staging.volvo.care/internal/transferservice/v1/transfer/addCarToCart'
    
    
       

    Given header Connection = 'keep-alive'
    And header accept = 'application/vnd.volvocars.api.x.transferresponse.v1+json'
    And header Content-Type = 'application/vnd.volvocars.api.carconfig.v1+json'
    And header User-Agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_16_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.117 Safari/537.36'
    And header QAWWW = '32204422-3a1d-49f7-9e93-e4de131c7885'

    And header Host =  'cdls.uswest2.staging.volvo.care'
    
    And def user = read('TransferServiceInput.json')
    
   
  Scenario: create a sample Post

 
    And request user
    When method post
    Then status 200
    * print response
    
       * def cartId = response.data.cartId
       * print cartId