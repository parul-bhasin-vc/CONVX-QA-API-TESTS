Feature: Functional API tests for Netherlands subscription flow

  Background:

    * def functions = karate.read('../common.js')()
    * def env = functions.readEnv()
    * def urlConfig = read('../api-config.json')[env]


    * def orderManagerBaseApi = 'https://internal.cdls.euwest1.staging.volvo.care/internal/ordermanager/v1/orders'
    * def addSessionApi = 'https://cdls.euwest1.staging.volvo.care/ccdp/transactbackend/v4/api/session/add'

  @Regression @testNow
  Scenario Outline: Validate NL <salesModel> E2E flow with apis

    * def transferServiceBaseApiURL = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].endpoint")
    * def transferServiceBaseApiHDR = karate.jsonPath(urlConfig, "$..[?(@.name == 'transferServiceBaseAPI')].header")[0][0]
    Given url transferServiceBaseApiURL+"addCarToCart"
    And headers transferServiceBaseApiHDR
    And def BodyOfRequest = read('../testData/'+'carConfigNL.json')
    And set BodyOfRequest.userinput.contractType = '<salesModel>'
    And set BodyOfRequest.userinput.input[0].value = '<contractLength>'
    And request BodyOfRequest
    When method POST
    Then status 200
    * def cartResponse = response
    Then print 'CheckoutURL --> ' + response.data.checkoutUrl

    Then match response.data.checkoutUrl contains 'guestAccessToken'

    Then print 'cartID --> ' + response.data.cartId
    * def cartId = response.data.cartId
    Then print 'VCC-SESSION --> ' + responseHeaders['vcc-session']
    * def vccSession = '' + responseHeaders['vcc-session'][0]

    * def orderManagerBaseApiURL = karate.jsonPath(urlConfig, "$..[?(@.name == 'OMBaseAPI')].endpoint")
    * def orderManagerBaseApiHDR = karate.jsonPath(urlConfig, "$..[?(@.name == 'OMBaseAPI')].header")[0][0]

    Given url orderManagerBaseApiURL + "orders/"
    And path cartId
    And headers orderManagerBaseApiHDR
    When method GET
    Then status 200
    * def orderResponse = response
    Then print 'GAT --> '+response.data.guestAccessToken
    * def gat = response.data.guestAccessToken
#    Then match the salesModel and validate the order lines.


    * def sessionBaseApiURL = karate.jsonPath(urlConfig, "$..[?(@.name == 'sessionBaseAPI')].endpoint")
    * def sessionBaseApiHDR = karate.jsonPath(urlConfig, "$..[?(@.name == 'sessionBaseAPI')].header")[0][0]

    Given url sessionBaseApiURL + "add"
#    * def sessionApiHeaders = {Content-Type: 'application/vnd.volvocars.api.x.accesstokenrequest.v1+json', vcc-session: ''}
    Then set sessionBaseApiHDR.vcc-session = vccSession
    Given headers sessionBaseApiHDR
    And def sessionApiRequest =
    """
      {
        "accessToken" : "",
        "orderId" : ""
      }
    """
    Then set sessionApiRequest.accessToken = gat
    And set sessionApiRequest.orderId = cartId
    Then request sessionApiRequest
    When method POST
    Then status 204

#    Given url 'https://cdls.euwest1.staging.volvo.care/ccdp/transactbackend/v4/api/userdetails/'+cartId+'/initialState'
#    * def globalInitialStateHeader =
#    """{
#      'accept': 'application/vnd.volvocars.api.x.initialstate.v1+json',
#      'vcc-session': ''
#    }"""
#    And set globalInitialStateHeader.vcc-session = vccSession
#    When method GET
#    Then status 200

    Examples:
    |  salesModel  | contractLength  |
    |     sub      |      24         |
    |  sub_fixed   |      48         |
    |    cash      |                 |
