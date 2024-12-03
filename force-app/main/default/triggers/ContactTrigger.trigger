trigger ContactTrigger on Contact (after delete) {
    List <Contact> oldContactList=new List<Contact>();
    for(Contact contact:Trigger.old){
        Contact con=contact.clone();
        con.id=null;
        con.LastName+=' Clone';
        oldContactList.add(con);
    }
    insert oldContactList;
}