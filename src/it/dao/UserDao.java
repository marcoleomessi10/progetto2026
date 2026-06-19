package it.dao;

import it.model.User;

public interface UserDao {

    User doRetrieveByEmailPassword(String email, String passwordHash);

    User doRetrieveByEmail(String email);

    void doSave(User user);
}
