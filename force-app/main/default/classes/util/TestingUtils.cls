@IsTest
public class TestingUtils {
    private static Integer startingNumber = 1;

    public static String generateId(Schema.SObjectType sObjectType) {
        String result = String.valueOf(startingNumber++);
        String keyPrefix = sObjectType.getDescribe().getKeyPrefix();
        if (keyPrefix == null) {
            switch on sObjectType.getDescribe().getAssociateEntityType() {
                when 'History' {
                    keyPrefix = '017';
                }
                when 'Share' {
                    keyPrefix = '02c';
                }
            }
        }
        return keyPrefix + '0'.repeat(12 - result.length()) + result;
    }

    public static SObject generateId(SObject objectInstance) {
        if (objectInstance.Id == null) {
            objectInstance.Id = generateId(objectInstance.getSObjectType());
        }
        return objectInstance;
    }

    public static void generateIds(List<SObject> records) {
        for (SObject record : records) {
            if (record.Id == null) {
                generateId(record);
            }
        }
    }

    @IsTest
    static void generates_fake_history_ids() {
        Assert.isNotNull(generateId(LeadHistory.SObjectType));
    }

    @IsTest
    static void generates_fake_share_records() {
        Assert.isNotNull(generateId(LeadShare.SObjectType));
    }

    public static SObject setReadOnlyField(SObject sobj, String fieldName, Object value) {
        return setReadOnlyField(sobj, new Map<String, Object>{ fieldName => value });
      }
      
      public static SObject setReadOnlyField(SObject sobj, Map<String, Object> changesToFields) {
        String serializedRecord = JSON.serialize(sobj);
        Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);
      
        // Loop through the deserialized record map and put the field & value
        // Since it's a map, if the field already exists on the SObject, it's updated (or added if it wasn't there already)
        for(String sobjectField : changesToFields.keySet()) {
          deserializedRecordMap.put(sobjectField, changesToFields.get(sobjectField));
        }
      
        serializedRecord = JSON.serialize(deserializedRecordMap);
        return (SObject) JSON.deserialize(serializedRecord, SObject.class);
      }
}