package com.harini.harinimart.dao;

import com.harini.harinimart.model.User;

public interface UserDAO {
    boolean registerUser(User user);
    User loginUser(String email, String password);
    boolean isEmailRegistered(String email);
}