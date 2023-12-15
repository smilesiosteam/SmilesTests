# SmilesTests
This repo contains some helper functions for unit test
## Functions
1. AwaitPublisher(publisher)
2. CollectNext
3. PublisherSpy
4. ReadJsonFile

## Usage
 ### 1. AwaitPublisher
This function takes parameters [publisher is required, timeout is optional] 
let's give an example.
In this code, the snippet contains functions that return a publisher under some logic and need to test the result
``` 
 func changeType(orderId: String, orderNumber: String) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.changeOrderType(orderId: orderId)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.showError(message: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    if let isChangeType = response.isChangeType, isChangeType {
                        promise(.success(.navigateToOrderConfirmation(orderId: orderId, orderNumber: orderNumber)))
                    } else {
                        promise(.success(.callOrderStatus))
                    }
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
        
    }
```

After we set the mock this is the test case 
```
  func test_changeType_successResponse_navigateToOrderConfirmation() throws {
        // Given
        let model = OrderChangeStub.getChangeTypeModel(isChanged: true)
        services.changeOrderTypeResponse = .success(model)
        let orderId = Constants.orderId.rawValue
        let orderNumber = Constants.orderNumber.rawValue
        // When
        let publisher = sut.changeType(orderId: orderId, orderNumber: orderNumber)
        let result = try awaitPublisher(publisher)
        // Then
        let expectedResult = ChangeTypeUseCase.State.navigateToOrderConfirmation(orderId: orderId, orderNumber: orderNumber)
        XCTAssertEqual(result, expectedResult, "Expected navigate to Order Confirmation but is not happened")
    }
    
```
 ### 2. CollectNext
 Use this type if you want to collect some of the events on the array to test each case 
 example 
 ```
  let results = PublisherSpy(sut.statePublisher.collectNext(5))
 ```
here we collect the first five events and set those in an array

 ### 3. PublisherSpy
 Use this to get the values from the publisher instead of vert time write sink to save time. 
 example 
 ```
func test_fetchOrderStates_success_orderProcessing()  {
        // Given
        let model = OrderStatusStub.getOrderStatusModel
        let result = PublisherSpy(sut.statePublisher.collectNext(5))
        services.getOrderTrackingStatus = .success(model)
        // When
        sut.fetchOrderStates()
        // Then
        let type: OrderTrackingUseCase.State = .orderId(id: "466715", orderNumber: "SMHD112020230000467215", orderStatus: .orderProcessing)
        XCTAssertEqual(result.value, [.hideLoader, .success(model: .init()), type, .isLiveTracking(isLiveTracking: false), .hideLoader])
    }
```
As you can see here I collect five events on an array and then match every event with what want to test, to make sure that  functions fetchOrderStates fire five events in order.

 ### 4. ReadJsonFile
 Use this function if you need to read JSON files and return a model to use this in stubs.
 example
 ```
 enum OrderStatusStub {
    static var getOrderStatusModel: OrderTrackingStatusResponse {
        let model: OrderTrackingStatusResponse? = readJsonFile("Order_Tracking_Model", bundle: .module)
        return model ?? .init()
    }
}
```


