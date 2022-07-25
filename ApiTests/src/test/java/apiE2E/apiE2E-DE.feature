@testNow
Feature: Functional API tests for Netherlands subscription flow

  Background:
    * def transferServiceBaseApi = 'https://cdls.euwest1.staging.volvo.care/internal/transferservice/v1/transfer/addCarToCart'
    * def orderManagerBaseApi = 'https://internal.cdls.euwest1.staging.volvo.care/internal/ordermanager/v1/orders'
    * def addSessionApi = 'https://cdls.euwest1.staging.volvo.care/ccdp/transactbackend/v4/api/session/add'

  @Regression
  Scenario Outline: Validate NL <salesModel> E2E flow with apis
    * def req_headers = {Content-Type: 'application/vnd.volvocars.api.carconfig.v1+json', accept: 'application/vnd.volvocars.api.x.transferresponse.v1+json'}
    * def dataPath = classpath: + ''
    Then print "Location of classPath ==> "+dataPath

    Given headers req_headers
    And url transferServiceBaseApi
    And def BodyOfRequest = read('carConfigDE.json')
    And set BodyOfRequest.userinput.contractType = '<salesModel>'
    And set BodyOfRequest.userinput.input[0].value = '<contractLength>'
    And set BodyOfRequest.userinput.customerType = '<customerType>'
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

    Given url orderManagerBaseApi
    And path cartId
#    * def req_headers2 = {accept : 'application/vnd.volvocars.api.ordermanager.order.v1+json'}
#    Then set headers req_headers2
    When method GET
    Then status 200
    * def orderResponse = response
    Then print 'GAT --> '+response.data.guestAccessToken
    * def gat = response.data.guestAccessToken
#    Then match the salesModel and validate the order lines.


    Given url addSessionApi
    * def sessionApiHeaders = {Content-Type: 'application/vnd.volvocars.api.x.accesstokenrequest.v1+json', vcc-session: ''}
    Then set sessionApiHeaders.vcc-session = vccSession
    Given headers sessionApiHeaders
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
      |    customerType   | salesModel  | contractLength  |
      |          b2b      |     sub     |      24         |
      |          b2b      |  sub_fixed  |      48         |
      |          b2b      |    cash     |       24          |
