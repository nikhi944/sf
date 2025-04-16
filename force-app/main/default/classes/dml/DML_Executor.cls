public virtual class DML_Executor implements DML_IOperations {
    private static DML_IOperations DML;

    protected DML_Executor() {
    }

    // provide a getter for use
    public static DML_IOperations getInstance() {
        if (DML == null) {
            if (Test.isRunningTest()) {
                DML = new DML_ExecutorMock();
            } else {
                DML = new DML_Executor();
            }
        }

        return DML;
    }

    private System.AccessLevel accessLevel = System.AccessLevel.SYSTEM_MODE;

    private Database.DMLOptions options {
        get {
            if (this.options == null) {
                this.options = new Database.DMLOptions();
                this.options.OptAllOrNone = true;
            }
            return this.options;
        }
        set;
    }

    public DML_Executor setOptions(Database.DMLOptions options, System.AccessLevel accessLevel) {
        if (accessLevel != null) {
            this.accessLevel = accessLevel;
        }

        if (options != null) {
            this.options = options;

            if (this.options.OptAllOrNone == null) {
                this.options.OptAllOrNone = true;
            }
        }

        return this;
    }

    public virtual Database.SaveResult doInsert(SObject record) {
        return this.doInsert(new List<SObject>{ record })[0];
    }

    public virtual List<Database.SaveResult> doInsert(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doInsert({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );
        List<Database.SaveResult> saveResults;

        try {
            if (records != null && !records.isEmpty()) {
                saveResults = Database.insert(records, this.options, this.accessLevel);

                logEvent.setDatabaseResult(saveResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doInsert({0})', records.toString()), e);
        }

        return saveResults;
    }

    public virtual Database.SaveResult doUpdate(SObject record) {
        return this.doUpdate(new List<SObject>{ record })[0];
    }

    public virtual List<Database.SaveResult> doUpdate(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doUpdate({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );

        List<Database.SaveResult> saveResults;

        try {
            if (records != null && !records.isEmpty()) {
                saveResults = Database.update(records, this.options, this.accessLevel);

                logEvent.setDatabaseResult(saveResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doUpdate({0})', records.toString()), e);
        }

        return saveResults;
    }

    public virtual Database.UpsertResult doUpsert(SObject record) {
        return this.doUpsert(new List<SObject>{ record })[0];
    }

    public virtual List<Database.UpsertResult> doUpsert(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doUpsert({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );

        List<Database.UpsertResult> upsertResults;

        try {
            if (records != null && !records.isEmpty()) {
                upsertResults = Database.upsert(records, this.options.OptAllOrNone, this.accessLevel);

                logEvent.setDatabaseResult(upsertResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doUpsert({0})', records.toString()), e);
        }

        return upsertResults;
    }

    public virtual List<Database.UpsertResult> doUpsert(List<SObject> records, Schema.SObjectField externalIdField) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage(
                'doUpsert({0}, {1}, {2}, {3})',
                new List<Object>{ records.toString(), this.options, this.accessLevel, externalIdField }
            )
        );

        List<Database.UpsertResult> upsertResults;

        try {
            if (records != null && !records.isEmpty()) {
                upsertResults = Database.upsert(records, externalIdField, this.options.OptAllOrNone, this.accessLevel);

                logEvent.setDatabaseResult(upsertResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doUpsert({0}, {1})', records.toString(), externalIdField), e);
        }

        return upsertResults;
    }

    public virtual Database.UndeleteResult doUndelete(SObject record) {
        return this.doUnDelete(new List<SObject>{ record })[0];
    }

    public virtual List<Database.UndeleteResult> doUndelete(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doUndelete({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );
        List<Database.UndeleteResult> undeleteResults;

        try {
            if (records != null && !records.isEmpty()) {
                undeleteResults = Database.undelete(records, this.options.OptAllOrNone, this.accessLevel);
                
                logEvent.setDatabaseResult(undeleteResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doUndelete({0})', records.toString()), e);
        }

        return undeleteResults;
    }

    public virtual Database.DeleteResult doDelete(SObject record) {
        return this.doDelete(new List<SObject>{ record })[0];
    }

    public virtual List<Database.DeleteResult> doDelete(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doDelete({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );
        
        List<Database.DeleteResult> deleteResults;

        try {
            if (records != null && !records.isEmpty()) {
                deleteResults = Database.delete(records, this.options.OptAllOrNone, this.accessLevel);
                
                logEvent.setDatabaseResult(deleteResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doDelete({0})', records.toString()), e);
        }

        return deleteResults;
    }

    public virtual Database.DeleteResult doHardDelete(SObject record) {
        return this.doHardDelete(new List<SObject>{ record })[0];
    }

    public virtual List<Database.DeleteResult> doHardDelete(List<SObject> records) {
        LogEntryEventBuilder logEvent = LOGGER.info(
            new LogMessage('doHardDelete({0}, {1}, {2})', records.toString(), this.options, this.accessLevel)
        );
        List<Database.DeleteResult> deleteResults;
        try {
            if (records != null && !records.isEmpty()) {
                deleteResults = this.doDelete(records);
                logEvent.setDatabaseResult(deleteResults);

                Database.emptyRecycleBin(records);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('doHardDelete({0})', records.toString()), e);
        }

        return deleteResults;
    }

    public virtual Database.SaveResult publish(SObject event) {
        LogEntryEventBuilder logEvent = Logger.info(new LogMessage('publish({0})', event.toString()));
        Database.SaveResult saveResult;

        try {
            if (event != null) {
                saveResult = EventBus.publish(event);
                
                logEvent.setDatabaseResult(saveResult);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('publish({0})', event.toString()), e);
        }

        return saveResult;
    }

    public virtual List<Database.SaveResult> publish(List<SObject> events) {
        LogEntryEventBuilder logEvent = Logger.info(new LogMessage('publish({0})', events.toString()));
        List<Database.SaveResult> saveResults;

        try {
            if (events != null && !events.isEmpty()) {
                saveResults = EventBus.publish(events);

                logEvent.setDatabaseResult(saveResults);
                Logger.saveLog();
            }
        } catch (Exception e) {
            Logger.exception(new LogMessage('publish({0})', events.toString()), e);
        }

        return saveResults;
    }
}