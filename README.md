# search_engine_oop
Convert last night's mess in to clean OOP code

Take your SQL code for your CREATE TABLE, INSERT INTO and UPDATE statements last night and convert it in to an OOP version with a class that has attributes and methods.

Normal Mode
All of the columns need to become attributes (or properties).

The CREATE TABLE statement needs to be moved in to a class method named create_table.

The INSERT INTO statement need to be moved in to an instance method named save.

For example, if you had a players table, you could create a class named Player with a name attribute and save method to write that Player object instance to the database table named players.

Store an attribute on the instance named id. When you first create an instance of the class, id should be nil (unless it was provided by an argument to the constructor).

When you save the object to the database, update the id attribute to be the value that was given to it for it's primary key. For example, if it was the first row in the table, the object's id would now be 1.

From then on, when save is called on that instance instead of performing an INSERT, it will now need to UPDATE the row in the database (as long as the object has an id and a row exists in the table with that id).
