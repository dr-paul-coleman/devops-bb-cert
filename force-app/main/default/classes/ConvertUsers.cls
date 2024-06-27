@IsTest( SeeAllData=true )
public class ConvertUsers {
    
    
    static
    {
        Id newProfileId = [SELECT Id from Profile WHERE Name = 'new Profile Name'].Id;
        User[] usersToConvert = new User[0];
        // change the limit in the next line for more than one record
        for( User[] users: [SELECT Id FROM User WHERE isActive = true AND Profile.Name = 'old Profile Name' LIMIT 1])
        {
            for( User u: users )
            {
                usersToConvert.add( new User(Id=u.Id, ProfileId=newProfileId) );
            }
        }
        
        
        Integer index = 0;
        Map<Id,String> errors = new Map<Id,String>();
        for( Database.SaveResult result: Database.update( usersToConvert, false ) )
        {
            if( !result.success )
            {
                errors.put( usersToConvert[index].Id, result.errors[0].message );
            }
            index++;
        }
        
        if( !errors.isEmpty() )
        {
            System.debug( LoggingLevel.ERROR, 'ERROR RECORDS\n' + JSON.serializePretty( errors ) );
        }
    }

}