public with sharing class Que_Finalizer implements Finalizer {
    private static final Que_SOQL SOQL = Que_SOQL.getInstance();
    private static final Que_Service SERVICE_QUE = Que_Service.getInstance();

    private Id currentRequestId;

    public Que_Finalizer() {
    }

    public void setAsyncRequestId(Id currentRequestId) {
        this.currentRequestId = currentRequestId;
    }

    public void execute(FinalizerContext context) {
        Logger.info('execute()');
        Logger.setAsyncContext(context);
        try{
            System.ParentJobResult result = Context.getResult();

            if( result == ParentJobResult.SUCCESS ){
            }else if ( result == ParentJobResult.UNHANDLED_EXCEPTION) {
                Exception ex = context.getException();
                LOGGER.error(new LogMessage('AsyncRequest resulted in an UNHANDLED_EXCEPTION {0}', currentRequestId, ex));
            }
        }catch(Exception ex){
            LOGGER.error(new LogMessage('AsyncRequest resulted in an UNHANDLED_EXCEPTION {0}', currentRequestId, ex));
        }finally{
            SERVICE_QUE.startQueueable(null);
            Logger.savelog();
        }
    }
}