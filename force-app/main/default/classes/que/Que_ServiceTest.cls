@IsTest(IsParallel = true)
public with sharing class Que_ServiceTest {
    
    @IsTest
    static void isAsyncRequestPending_False_WithoutAsyncRequests() {
        //Arrange
        Mock SOQL_MOCK = Mock.forType(Que_SOQL.class);
        MethodSpy getPendingAsyncRequestsSpy = SOQL_MOCK.spyOn('getPendingAsyncRequests');
        getPendingAsyncRequestsSpy.returns(new List<Que_AsyncRequest__c>());

        Que_Service SERVICE = Que_Service.getInstance();
        Que_Service.SOQL = (Que_SOQL) SOQL_MOCK.stub;

        //Act
        Boolean isAsyncRequestPending = SERVICE.isAsyncRequestPending();

        //Assert
        Expect.that(getPendingAsyncRequestsSpy).hasBeenCalledTimes(1);
        Assert.isFalse(isAsyncRequestPending, 'DB is without Que_AsyncRequests');        
    }

    @IsTest
    static void isAsyncRequestPending_False_HasAsyncRequests() {
        //Arrange
        Mock SOQL_MOCK = Mock.forType(Que_SOQL.class);
        MethodSpy getPendingAsyncRequestsSpy = SOQL_MOCK.spyOn('getPendingAsyncRequests');
        getPendingAsyncRequestsSpy.returns(new List<Que_AsyncRequest__c>{new Que_AsyncRequest__c()});

        Que_Service SERVICE = Que_Service.getInstance();
        Que_Service.SOQL = (Que_SOQL) SOQL_MOCK.stub;

        //Act
        Boolean isAsyncRequestPending = SERVICE.isAsyncRequestPending();

        //Assert
        Expect.that(getPendingAsyncRequestsSpy).hasBeenCalledTimes(1);
        Assert.isTrue(isAsyncRequestPending, 'We want to queue the next asyncrequest');        
    }
}